#!/usr/bin/env fish

argparse 'theme=' 'fallback=' -- $argv 2>/dev/null

set -l history_file "$HOME/.local/share/rofi/search_history"

mkdir -p (dirname $history_file)

set -l history_entries
if test -f "$history_file"
    set history_entries (cat $history_file)
end

set -l selection (printf '%s\n' $history_entries | rofi -dmenu -p '' -i -theme "$_flag_theme")

if test -z "$selection"
    if test -n "$_flag_fallback" -a -e "$_flag_fallback"
        eval "$_flag_fallback" &
    end
else
    if string match -q "!*" "$selection" && string match -q "* *" "$selection"
        set -l query (string replace -r '^![^ ]+ ' '' "$selection")
        if test -n "$query" && not contains -- "$query" $history_entries
            echo $query >> $history_file
        end
    else
        if not contains -- "$selection" $history_entries
            echo $selection >> $history_file
        end
    end
    xdg-open "https://duckduckgo.com/?q="(string escape --style=url "$selection") &
end

