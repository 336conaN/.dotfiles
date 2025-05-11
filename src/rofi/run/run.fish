#!/usr/bin/env fish

argparse 'theme=' 'fallback=' -- $argv 2>/dev/null

set -l history_file "$HOME/.local/share/rofi/run_history"

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
    set -l command (string match -r '^([^ |]+)' $selection)[2]
    if command -v $command >/dev/null 2>&1
        if not contains -- "$selection" $history_entries
            echo $selection >> $history_file
        end
        eval $selection &
    else
        notify-send -u critical -t 2000 "Rofi" "Command not found: $command"
    end
end

