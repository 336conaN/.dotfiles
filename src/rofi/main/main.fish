#!/usr/bin/env fish

set dir (status dirname)
set font "SFMono Nerd Font"
set theme "$dir/../theme/theme.rasi"
set source "$dir/config.yaml"

set options
set actions

set entries (yq eval '.entries[] | [.icon, .color, .title, .command] | @tsv' $source)

for entry in $entries
    set fields (string split \t $entry)
    set options $options "<span foreground='$fields[2]' font_family='$font'>$fields[1]</span>$fields[3]"
    set actions $actions $fields[4]
end

set selection (printf '%s\n' $options | rofi -dmenu -p "" -theme "$theme" -i -matching fuzzy -markup-rows)

if test -n "$selection"
    set index (contains -i -- "$selection" $options)
    if test -n "$index"
        eval $actions[$index] &
    else
        notify-send -u critical -t 2000 "Rofi" "Invalid selection: $selection"
    end
end

