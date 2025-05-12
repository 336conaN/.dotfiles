#!/usr/bin/env fish

set dir (status dirname)
set font "SFMono Nerd Font"
set theme "$dir/../theme/theme.rasi"
set source "$dir/config.yaml"
set fallback "$dir/../main/main.fish"

set options (yq eval '.entries[] | "<span foreground=\"" + .color + "\" font_family=\"'$font'\">" + .icon + "</span>" + .title' $source)
set actions (yq eval '.entries[].command' $source)

set selection (printf '%s\n' $options | rofi -dmenu -p "" -theme "$theme" -i -matching fuzzy -markup-rows)

if test -z "$selection"
    if test -n "$fallback" -a -e "$fallback"
        eval "$fallback" &
    end
else
    set index (contains -i -- "$selection" $options)
    if test -n "$index"
        eval $actions[$index] &
    else
        notify-send -u critical -t 2000 "Rofi" "Invalid selection: $selection"
        if test -n "$fallback" -a -e "$fallback"
            eval "$fallback" &
        end
    end
end

