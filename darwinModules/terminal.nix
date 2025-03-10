{ pkgs, lib, config, ... }: {

  options = {
    terminal.enable =
      lib.mkEnableOption "enables terminal bundle";
  };

  config = lib.mkIf config.terminal.enable {
    environment.systemPackages = with pkgs; [
      nixd
      nil
      mc
      bat
      eza
      lsd
      fd
      fzf
      ripgrep
      nushell
      zoxide
    ];

    home-manager.users.arcadia = {
      programs = {
        wezterm = {
          enable = true;
        };

        tmux = {
          enable = true;
          sensibleOnTop = true;
          historyLimit = 20000;
          escapeTime = 0;
          baseIndex = 1;
          newSession = true;
          terminal = "tmux-256color";

          extraConfig = ''
              # set-option -g default-terminal 'screen-256color'
              set-option -g terminal-overrides ',xterm-256color:RGB'
              set -gu default-command

              set -g detach-on-destroy off     # don't exit from tmux when closing a session
              set -g renumber-windows on       # renumber all windows when any window is closed
              set -g set-clipboard on          # use system clipboard
              set -g status-position top       # macOS / darwin style
              setw -g mode-keys vi
              set -g pane-active-border-style 'fg=magenta,bg=default'
              set -g pane-border-style 'fg=brightblack,bg=default'

#             # set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
#             # set -g @fzf-url-history-limit '2000'

#             bind s choose-session
        '';

          plugins =
          with pkgs; [
            # tmuxPlugins.sensible
            tmuxPlugins.copycat
            tmuxPlugins.yank
            # must be before continuum edits right status bar
            {
                plugin = tmuxPlugins.catppuccin;
                extraConfig = ''
                  set -g @catppuccin_window_left_separator ""
                  set -g @catppuccin_window_right_separator " "
                  set -g @catppuccin_window_middle_separator "█"
                  set -g @catppuccin_window_number_position "left"
                  set -g @catppuccin_window_default_fill "number"
                  set -g @catppuccin_window_default_text " #W"
                  set -g @catppuccin_window_current_fill "number"
                  set -g @catppuccin_window_current_text " #W#{?window_zoomed_flag,(),}"
                  set -g @catppuccin_status_modules_right "directory meetings date_time"
                  set -g @catppuccin_status_modules_left "session"
                  set -g @catppuccin_status_left_separator  " "
                  set -g @catppuccin_status_right_separator " "
                  set -g @catppuccin_status_right_separator_inverse "no"
                  set -g @catppuccin_status_fill "icon"
                  set -g @catppuccin_status_connect_separator "no"
                  set -g @catppuccin_directory_text "#{b:pane_current_path}"
                  set -g @catppuccin_date_time_text "%H:%M"
                '';
            }
            {
                plugin = tmuxPlugins.resurrect;
                extraConfig = ''
                set -g @resurrect-strategy-vim 'session'
                set -g @resurrect-strategy-nvim 'session'
                set -g @resurrect-capture-pane-contents 'on'
                '';
            }
            {
                plugin = tmuxPlugins.continuum;
                extraConfig = ''
                set -g @continuum-restore 'on'
                # set -g @continuum-boot 'on'
                set -g @continuum-save-interval '10'
                '';
            }

            tmuxPlugins.tmux-thumbs
            tmuxPlugins.tmux-fzf
            tmuxPlugins.fzf-tmux-url
            tmuxPlugins.session-wizard
            tmuxPlugins.open
            {
              plugin = tmuxPlugins.better-mouse-mode;
              extraConfig = ''
                set -g @scroll-speed-num-lines-per-scroll "1"
                set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
              '';
            }
          ];
        };

        zsh = {
          enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;

          history = {
            size = 100000;
            save = 2000000;
          };
        };

        starship = {
          enable = true;
          enableZshIntegration = true;
        };
      };
      home.file = {
        ".config/starship.toml".source = ../dotfiles/jetpack.toml;
      };
    };
  };
}
