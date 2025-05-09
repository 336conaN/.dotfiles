if status is-interactive
#===================================================================================================================================================#
  set -g fish_greeting ""
  set -g fish_key_bindings fish_vi_key_bindings
#===================================================================================================================================================#

#===================================================================================================================================================#
  bind -M default tab "complete"
  bind -M default shift-tab "accept-autosuggestion"
  bind -M insert tab "complete"
  bind -M insert shift-tab "accept-autosuggestion"
  bind -M visual tab "complete"
  bind -M visual shift-tab "accept-autosuggestion"
  bind -M default p fish_clipboard_paste
  bind -M visual p fish_clipboard_paste
  bind -M default / "commandline -r (history search | fzf)"
  bind -M default f "yzcd"
#===================================================================================================================================================#

#===================================================================================================================================================#
  alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
  alias la="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions -A"
  alias tl="tree -C"
  alias ta="tree -C -a"
  alias vi="nvim"
  alias lg="lazygit"
#===================================================================================================================================================#

#===================================================================================================================================================#
  abbr rebuild "sudo nixos-rebuild switch --flake ~/.dotfiles/src/nix/"
  abbr garbage "sudo nix-collect-garbage --delete-old"
  abbr matrix "cmatrix -C blue"
  abbr bonsai "cbonsai -l -i"
#===================================================================================================================================================#

#===================================================================================================================================================#
  zoxide init --cmd cd fish |
    source

  function yzcd
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
  end
#===================================================================================================================================================#

#===================================================================================================================================================#
  function fish_prompt
    printf (set_color normal)" "
  end

  function fish_mode_prompt
    switch $fish_bind_mode
      case default
        printf (set_color "#8caaee")""
      case insert
        printf (set_color "#a6d189")""
      case replace_one
        printf (set_color "#e5c890")""
      case visual
        printf (set_color "#ca9ee6")""
    end
  end
#===================================================================================================================================================#

#===================================================================================================================================================#
  if status is-login; and test (tty) = "/dev/tty1"
    set -l hyprland_session_lock $XDG_RUNTIME_DIR/hyprland_session_lock
    if not test -e $hyprland_session_lock
      touch $hyprland_session_lock
      exec Hyprland
    end
  end
#===================================================================================================================================================#

#===================================================================================================================================================#
  if not string match -q "/dev/tty*" (tty); and not set -q TMUX; and type -q tmux
    if tmux has-session -t Default 2>/dev/null
      set -l clients (tmux list-clients -t Default 2>/dev/null | count)
      if test $clients -eq 0
        exec tmux attach -t Default
      end
    else
      exec tmux new-session -s Default
    end
  end
#===================================================================================================================================================#
end

