#!/usr/bin/env fish

set -l dir (status dirname)
set -l font "SFMono Nerd Font"
set -l fallback "$dir/../main/main.fish"
set -l theme "$dir/../theme/theme.rasi"

set -l icon '<span foreground="#e5c890" font_family="$font"> </span>'

set -l input (fd . $HOME -H -t d | sed -e "s|^$HOME|~|" -e "s|^|$icon|" | rofi -dmenu -p "" -theme "$theme" -i -matching fuzzy -markup-rows)
set -l output (printf "%s\n" $input | sed -e "s|^$icon||" -e "s|^~|$HOME|")

if test -z "$input"
  if test -n "$fallback"
    eval "$fallback" &
  end
else
  if test -e "$output"
    xdg-open "$output" &
  else
    notify-send -u critical -t 2000 "Rofi" "Path does not exist: $output"
    if test -n "$fallback"
      eval "$fallback" &
    end
  end
end

