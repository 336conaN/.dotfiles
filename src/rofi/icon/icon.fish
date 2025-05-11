#!/usr/bin/env fish

argparse 'source=' 'theme=' 'fallback=' -- $argv 2>/dev/null

set -l content (cat $_flag_source)

set -l selection (printf '%s\n' $content | rofi -dmenu -p '' -i -theme "$_flag_theme")

if test -z "$selection"
    if test -n "$_flag_fallback" -a -e "$_flag_fallback"
        eval "$_flag_fallback" &
    end
else
    if string match -q -- "*$selection*" "$(printf '%s\n' $content)"
        set -l icon (string match -r '^\S+' $selection)
        printf '%s' $icon | wl-copy
        notify-send -t 2000 "Rofi" "$icon  copied to clipboard"
    else
        notify-send -u critical -t 2000 "Rofi" "No matching icon found"
    end
end

