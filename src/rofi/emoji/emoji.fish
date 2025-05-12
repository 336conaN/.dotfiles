#!/usr/bin/env fish

argparse 'source=' 'theme=' 'fallback=' -- $argv 2>/dev/null

set -l content (cat $_flag_source)
set -l selection (printf '%s\n' $content | rofi -dmenu -p '' -i -theme "$_flag_theme")

if test -z "$selection"
    test -n "$_flag_fallback" -a -e "$_flag_fallback"; and eval "$_flag_fallback" &
else if contains -- "$selection" $content
    set -l emoji (string split -m1 ' ' -- $selection)[1]
    printf '%s' $emoji | wl-copy
    notify-send -t 2000 "Rofi" "$emoji copied to clipboard"
else
    notify-send -u critical -t 2000 "Rofi" "⚠️ No match found"
    test -n "$_flag_fallback" -a -e "$_flag_fallback"; and eval "$_flag_fallback" &
end

