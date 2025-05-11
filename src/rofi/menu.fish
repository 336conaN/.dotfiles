#!/usr/bin/env fish

set -l font "SF Mono Nerd Font"
set -l theme "$HOME/.dotfiles/src/rofi/theme.rasi"
set -l fallback ""
set -l source "$HOME/.dotfiles/src/rofi/source/main.yaml"

argparse 'font=' 'theme=' 'fallback=' 'source=' -- $argv 2>/dev/null

set font (test -n "$_flag_font" && echo "$_flag_font" || echo "$font")
set theme (test -n "$_flag_theme" && echo "$_flag_theme" || echo "$theme")
set fallback (test -n "$_flag_fallback" && echo "$_flag_fallback" || echo "$fallback")
set source (test -n "$_flag_source" && echo "$_flag_source" || echo "$source")

set -l options
set -l actions

set -l entries (yq eval '.entries[] | [.icon, .color, .title, .command] | @tsv' $source)

for entry in $entries
  set -l fields (string split \t $entry)
  set -a options "<span foreground='$fields[2]' font_family='$font'>$fields[1]</span>$fields[3]"
  set -a actions $fields[4]
end

set -l selection (printf '%s\n' $options | rofi -dmenu -p '' -theme "$theme" -i -markup-rows)

if test -z "$selection"
  if test -n "$fallback" -a -e "$fallback"
    eval "$fallback" &
  end
else
  set -l index (contains -i -- "$selection" $options)
  if test -n "$index"
    eval $actions[$index] &
  else
    notify-send -u critical -t 2000 "Rofi" "Invalid selection: $selection"
  end
end

