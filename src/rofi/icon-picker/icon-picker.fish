#!/usr/bin/env fish

set -l dir (status dirname)
set -l fallback "$dir/../main/main.fish"
set -l theme "$dir/../theme/theme.rasi"
set -l source "$dir/icon-source.txt"

set -l content (cat "$source")
set -l selection (printf '%s\n' $content | rofi -dmenu -p "" -theme "$theme" -i -matching fuzzy)

if test -z "$selection"
    test -n "$fallback" -a -e "$fallback"; and eval "$fallback" &
else if contains -- "$selection" $content
    set -l icon (string split -m1 ' ' -- $selection)[1]
    printf '%s' $icon | wl-copy
    notify-send -t 2000 "Rofi" "$icon  copied to clipboard"
else
    notify-send -u critical -t 2000 "Rofi" "⚠️ No match found"
    test -n "$fallback" -a -e "$fallback"; and eval "$fallback" &
end

