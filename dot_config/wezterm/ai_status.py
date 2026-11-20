#!/usr/bin/env python3
"""Local, read-only Claude/Codex usage collector for WezTerm (Python stdlib)."""
import argparse
import datetime as dt
import fcntl
import glob
import json
import math
import os
from pathlib import Path
import re
import selectors
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.request

CACHE = Path(os.environ.get('AI_STATUS_CACHE', str(Path.home() / '.cache/wezterm-ai-status')))
RATE_TTL = 120


def read_json(path):
    try:
        return json.loads(path.read_text())
    except (OSError, ValueError):
        return {}


def atomic_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    fd, name = tempfile.mkstemp(prefix='.' + path.name, dir=str(path.parent))
    try:
        with os.fdopen(fd, 'w') as f:
            json.dump(value, f, ensure_ascii=False)
        os.replace(name, path)
    finally:
        if os.path.exists(name):
            os.unlink(name)


def number(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value)


def timestamp(value):
    if number(value):
        return value
    try:
        return dt.datetime.fromisoformat(value.replace('Z', '+00:00')).timestamp()
    except (AttributeError, ValueError, TypeError):
        return None


def update_rates(previous, snapshot):
    """Retain each last known limit when a response omits it."""
    limits = {w['label']: dict(w, updated=w.get('updated', previous.get('limits_at')), missing=True)
              for w in previous.get('limits') or []}
    for w in snapshot['limits']:
        limits[w['label']] = dict(w, updated=snapshot['limits_at'], missing=False)
    previous.update(snapshot)
    previous['limits'] = list(limits.values())


def merge_claude(account, hook):
    # Hooks only contain common limits. Never replace account-only model limits
    # or hide an account request failure with a newer hook timestamp.
    state = dict(account)
    limits = {w['label']: dict(w) for w in account.get('limits') or []}
    for w in hook.get('limits') or []:
        old = limits.get(w['label'])
        hook_at = w.get('updated', hook.get('limits_at')) or 0
        account_at = (old or {}).get('updated', account.get('limits_at')) or 0
        if old is None or hook_at > account_at:
            limits[w['label']] = dict(w)
    state['limits'] = list(limits.values())
    if not state.get('limits_at'):
        state['limits_at'] = hook.get('limits_at')
    return state


def ingest_claude(data):
    # Do not persist transcript contents, paths, credentials or raw hook input.
    now = time.time()
    limits = []
    for key, label in [('five_hour', '5h'), ('seven_day', '7d')]:
        item = (data.get('rate_limits') or {}).get(key) or {}
        if number(item.get('used_percentage')):
            limits.append({'label': label, 'used': item['used_percentage'],
                           'reset': timestamp(item.get('resets_at'))})
    state = read_json(CACHE / 'claude.json')
    state['updated'] = now
    if limits:
        update_rates(state, {'limits': limits, 'limits_at': now})
    atomic_json(CACHE / 'claude.json', state)


def codex_binary():
    candidates = [os.environ.get('AI_STATUS_CODEX'), shutil.which('codex'),
                  str(Path.home()/'.local/share/mise/shims/codex'),
                  str(Path.home()/'.volta/bin/codex'), '/opt/homebrew/bin/codex']
    candidates += sorted(glob.glob(str(Path.home()/'.local/share/mise/installs/node/*/bin/codex')), reverse=True)
    for p in candidates:
        if p and os.path.isfile(p) and os.access(p, os.X_OK):
            return p
    raise FileNotFoundError('codex')


def codex_rates():
    binary = codex_binary()
    env = os.environ.copy()
    env['PATH'] = str(Path(binary).parent) + os.pathsep + env.get('PATH', '/usr/bin:/bin')
    # A separate stdio connection: never resume threads or consume reset credits.
    p = subprocess.Popen([binary, 'app-server', '--stdio'], stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, env=env)
    sel = selectors.DefaultSelector()
    sel.register(p.stdout, selectors.EVENT_READ)
    buffer = b''
    deadline = time.monotonic() + 20

    def send(value):
        p.stdin.write((json.dumps(value) + '\n').encode())
        p.stdin.flush()

    def call(i, method, params):
        nonlocal buffer
        send({'id': i, 'method': method, 'params': params})
        while time.monotonic() < deadline:
            if b'\n' not in buffer:
                if not sel.select(max(0, deadline - time.monotonic())):
                    break
                chunk = os.read(p.stdout.fileno(), 65536)
                if not chunk:
                    raise RuntimeError('app-server disconnected')
                buffer += chunk
                continue
            line, buffer = buffer.split(b'\n', 1)
            msg = json.loads(line)
            if msg.get('id') == i:
                if 'error' in msg:
                    raise RuntimeError('app-server request failed')
                return msg['result']
        raise TimeoutError('app-server timeout')
    try:
        call(0, 'initialize', {'clientInfo': {'name': 'wezterm_usage_status', 'version': '1.0'},
                               'capabilities': {}})
        send({'method': 'initialized'})
        return call(1, 'account/rateLimits/read', None)
    finally:
        sel.close()
        p.terminate()
        try:
            p.wait(timeout=2)
        except subprocess.TimeoutExpired:
            p.kill()
            p.wait()
        p.stdin.close()
        p.stdout.close()


def normalize_rates(result, now):
    snapshot = (result.get('rateLimitsByLimitId') or {}).get('codex') or result.get('rateLimits') or {}
    limits = []
    for key in ['primary', 'secondary']:
        w = snapshot.get(key) or {}
        mins = w.get('windowDurationMins')
        if not number(w.get('usedPercent')):
            continue
        if number(mins) and mins > 0:
            label = ('%gd' % (mins / 1440)) if mins % 1440 == 0 else ('%gh' % (mins / 60)) if mins % 60 == 0 else '%gm' % mins
        else:
            label = key
        limits.append({'label': label, 'used': w['usedPercent'], 'reset': timestamp(w.get('resetsAt'))})
    if not limits:
        raise ValueError('No known Codex usage fields')
    summary = result.get('rateLimitResetCredits') or {}
    count = summary.get('availableCount')
    rows = summary.get('credits')
    available = [r for r in (rows or []) if r.get('status') == 'available']
    dates = [timestamp(r.get('expiresAt')) for r in available]
    dates = [d for d in dates if d is not None]
    # A capped response or any unknown expiration cannot prove the earliest date.
    complete = isinstance(rows, list) and number(count) and len(available) == count and len(dates) == count
    return {'limits': limits, 'limits_at': now, 'reset_count': count,
            'earliest_expiry': min(dates) if dates else None, 'expiry_complete': complete,
            'rate_error': None}


def normalize_claude_rates(data, now):
    limits = []
    for key, label in [('five_hour', '5h'), ('seven_day', '7d')]:
        item = data.get(key) or {}
        if number(item.get('utilization')):
            limits.append({'label': label, 'used': item['utilization'],
                           'reset': timestamp(item.get('resets_at'))})
    for item in data.get('limits') or []:
        label = {'session': '5h', 'weekly_all': '7d'}.get(item.get('kind'))
        if item.get('kind') == 'weekly_scoped':
            model = ((item.get('scope') or {}).get('model') or {}).get('display_name')
            if isinstance(model, str):
                label = re.sub(r'[^a-zA-Z0-9_.-]', '', model)[:12] or None
        if label and number(item.get('percent')) and not any(w['label'] == label for w in limits):
            limits.append({'label': label, 'used': item['percent'],
                           'reset': timestamp(item.get('resets_at'))})
    if not limits:
        raise ValueError('No known Claude usage fields')
    return {'limits': limits, 'limits_at': now, 'rate_error': None}


def claude_rates():
    # Same account endpoint and Keychain entry as the existing Claude status script.
    # Credentials stay in process memory, never command arguments or cache files.
    r = subprocess.run(['/usr/bin/security', 'find-generic-password', '-s',
                        'Claude Code-credentials', '-w'], capture_output=True, timeout=5)
    if r.returncode:
        raise RuntimeError('Claude credentials unavailable')
    token = (json.loads(r.stdout).get('claudeAiOauth') or {}).get('accessToken')
    if not isinstance(token, str) or not token:
        raise RuntimeError('Claude access token unavailable')
    request = urllib.request.Request('https://api.anthropic.com/api/oauth/usage', headers={
        'Authorization': 'Bearer ' + token, 'anthropic-beta': 'oauth-2025-04-20'})
    with urllib.request.urlopen(request, timeout=8) as response:
        return json.load(response)


def age_label(at, now):
    if not number(at):
        return '?'
    seconds = max(0, now-at)
    if seconds < 3600:
        return '%dm' % (seconds//60)
    if seconds < 86400:
        return '%dh' % (seconds//3600)
    return '%dd' % (seconds//86400)


def when(at, now, compact=False):
    if not number(at):
        return '?'
    if compact:
        secs = at-now
        if secs <= 0:
            return '0m'
        if secs < 3600:
            return '%dm' % math.ceil(secs/60)
        if secs < 86400:
            return '%dh%dm' % (secs//3600, (secs%3600)//60)
        return '%dd%dh' % (secs//86400, (secs%86400)//3600)
    return dt.datetime.fromtimestamp(at).strftime('%m/%d %H:%M')


def remaining_gauge(used):
    if not number(used):
        return '?'
    remaining = int(round(max(0, min(100, 100 - used))))
    filled = remaining // 10
    return '█' * filled + '░' * (10 - filled) + ' %d%%' % remaining


def render(provider, state, now, compact=False):
    name = 'Claude' if provider == 'claude' else 'Codex'
    limits = state.get('limits') or []
    stale = now - (state.get('limits_at') or 0) > 300
    failed = bool(state.get('rate_error')) or not limits or stale or any(w.get('missing') for w in limits)
    parts = [name + (' ×' if failed else ' ○')]
    for w in limits:
        label = w['label'] + (' ×' if w.get('missing') else '')
        parts.append('%s %s (→%s)' % (label, remaining_gauge(w['used']), when(w.get('reset'), now, True)))
    if not limits:
        parts.append('limits ?')
    elif stale or state.get('rate_error'):
        parts.append('stale ' + age_label(state.get('limits_at'), now))
    if provider == 'codex':
        count = state.get('reset_count')
        parts.append('resets ' + (str(count) if number(count) else '?'))
        if number(count) and count > 0:
            expires = state.get('earliest_expiry')
            marker = 'exp' if state.get('expiry_complete') else 'exp?'
            value = when(expires, now, False)
            if compact and number(expires):
                value = dt.datetime.fromtimestamp(expires).strftime('%m/%d')
            parts.append(marker + ' ' + value)
    return ' | '.join(parts)


def build_display(claude, codex, now):
    return {'updated': now, 'claude': {'full': render('claude', claude, now),
                                      'compact': render('claude', claude, now, True)},
            'codex': {'full': render('codex', codex, now),
                      'compact': render('codex', codex, now, True)}}


def collect(force=False):
    CACHE.mkdir(parents=True, exist_ok=True, mode=0o700)
    with (CACHE/'collector.lock').open('a') as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return
        now = time.time()
        previous = read_json(CACHE/'display.json')
        if not force and now - previous.get('updated', 0) < 10:
            return
        codex = read_json(CACHE/'codex.json')
        for key in ['context', 'context_at', 'session']:
            codex.pop(key, None)
        if force or now - codex.get('rate_attempt_at', 0) >= RATE_TTL:
            codex['rate_attempt_at'] = now
            try:
                update_rates(codex, normalize_rates(codex_rates(), time.time()))
            except (OSError, RuntimeError, TimeoutError, ValueError, subprocess.SubprocessError) as e:
                codex['rate_error'] = type(e).__name__
        atomic_json(CACHE/'codex.json', codex)
        claude = read_json(CACHE/'claude.json')
        account = read_json(CACHE/'claude-account.json')
        if force or now - account.get('rate_attempt_at', 0) >= RATE_TTL:
            account['rate_attempt_at'] = now
            try:
                update_rates(account, normalize_claude_rates(claude_rates(), time.time()))
            except (OSError, RuntimeError, TimeoutError, ValueError, subprocess.SubprocessError) as e:
                account['rate_error'] = type(e).__name__
            atomic_json(CACHE/'claude-account.json', account)
        claude = merge_claude(account, claude)
        atomic_json(CACHE/'display.json', build_display(claude, codex, time.time()))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=['collect', 'ingest-claude', 'show'])
    parser.add_argument('--force', action='store_true')
    args = parser.parse_args()
    if args.command == 'ingest-claude':
        ingest_claude(json.load(sys.stdin))
    elif args.command == 'collect':
        collect(args.force)
    else:
        state = read_json(CACHE/'display.json')
        for key in ['claude', 'codex']:
            print((state.get(key) or {}).get('full', key + ': waiting'))


if __name__ == '__main__':
    main()
