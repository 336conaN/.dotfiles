#!/usr/bin/env fish

set -l dir (status dirname)
set -l fallback "$dir/../main/main.fish"
set -l theme "$dir/../theme/theme.rasi"

set -l history_file "$HOME/.local/share/rofi/search_history"
mkdir -p (dirname $history_file)

set -l history_entries
if test -f "$history_file"
    set history_entries (cat $history_file)
end

set -l selection (printf '%s\n' $history_entries | rofi -dmenu -p "" -theme "$theme" -i -matching fuzzy -markup-rows)

if test -z "$selection"
    if test -n "$fallback" -a -e "$fallback"
        eval "$fallback" &
    end
else
    if not contains -- "$selection" $history_entries
        echo $selection >> $history_file
    end
    eval xdg-open "https://google.com/search?q="(string escape --style=url "$selection") &
end
