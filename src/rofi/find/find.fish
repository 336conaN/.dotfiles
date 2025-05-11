#!/usr/bin/env fish

argparse 'font=' 'theme=' 'fallback=' 'rule=+' 'exclude=+' -- $argv 2>/dev/null

set -l rules
set -l excludes

for rule in $_flag_rule
  set -l parts (string split "|" $rule)
  set -a rules -e "\\|$parts[1]\$| {s|^|<span font=\"$_flag_font\" color=\"$parts[3]\">$parts[2]</span>|;b;}"
end

for exclude in $_flag_exclude
  set -a excludes -E $exclude
end

set -l selection (fd -H . $HOME $excludes | sed -e "s|^$HOME|~|" $rules | rofi -dmenu -p "" -theme "$_flag_theme" -i -markup-rows)

if test -z "$selection"
  if test -n "$_flag_fallback"
    eval "$_flag_fallback" &
  end
else
  set -l clean (printf '%s\n' $selection | sed -e 's|<[^>]*>||g; s|^[^ ]* ||; s|^~|'"$HOME"'|')
  if test -e "$clean"
    xdg-open "$clean" &
  else
    notify-send -u critical -t 2000 "Rofi" "Path does not exist: $clean"
  end
end

