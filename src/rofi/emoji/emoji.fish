#!/usr/bin/env fish

set -l dir (status dirname)

set -l config "$dir/../config.yaml"
set -l source "$dir/emoji.txt"

set -l theme (yq -r '.variables.theme' "$config" | string replace '~' $HOME)
set -l fallback (yq -r '.variables.fallback' "$config" | string replace '~' $HOME)

set -l content (cat "$source")
set -l selection (printf '%s\n' $content | rofi -dmenu -p '' -i -theme "$theme")

if test -z "$selection"
    test -n "$fallback" -a -e "$fallback"; and eval "$fallback" &
else if contains -- "$selection" $content
    set -l emoji (string split -m1 ' ' -- $selection)[1]
    printf '%s' $emoji | wl-copy
    notify-send -t 2000 "Rofi" "$emoji copied to clipboard"
else
    notify-send -u critical -t 2000 "Rofi" "⚠️ No match found"
    test -n "$fallback" -a -e "$fallback"; and eval "$fallback" &
end
