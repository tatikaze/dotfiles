#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch
for monitor in `xrandr -q | grep " connected" | cut -d ' ' -f1`; do
  MONITOR=$monitor polybar main &
done

echo "Bar launched..."
