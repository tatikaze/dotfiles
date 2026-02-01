function gim
  if [ -n "$argv" ]
    set GREP_RESULT ( \
      grep -n $argv[1] -r $argv[2] | \
      fzf --preview "bat --color=always --style=header,grid -H (echo {} | sed -e 's/^\([^:]*\):\([0-9]*\).*\$/\2/') --line-range :80 (echo {} | sed -e 's/^\([^:]*\):\([0-9]*\).*\$/\1/')" \
    )

    set FILE_NAME (echo $GREP_RESULT | sed -e 's/^\([^:]*\):\([0-9]*\).*$/\1/')
    set NUMBER    (echo $GREP_RESULT | sed -e 's/^\([^:]*\):\([0-9]*\).*$/\2/')


    echo $FILE_NAME
    if [ -n "$FILE_NAME" ]; vim $FILE_NAME +$NUMBER; end
  end
end
