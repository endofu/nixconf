{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.tmux;
in {
  options.modules.shell.tmux = {
    enable = mkEnableOption "tmux configuration";
    
    keyMode = mkOption {
      type = types.enum [ "emacs" "vi" ];
      default = "emacs";
      description = "Key binding mode for tmux";
    };
    
    shell = mkOption {
      type = types.str;
      default = "";
      description = "Default shell to use in tmux";
      example = "\${pkgs.zsh}/bin/zsh";
    };
    
    terminal = mkOption {
      type = types.str;
      default = "screen-256color";
      description = "Terminal to use";
    };
    
    plugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "List of tmux plugins to install";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      
      keyMode = cfg.keyMode;
      terminal = cfg.terminal;
      shell = mkIf (cfg.shell != "") cfg.shell;
      
      sensibleOnTop = true;
      historyLimit = 20000;
      escapeTime = 0;
      baseIndex = 1;
      newSession = false;
      
      plugins = with pkgs.tmuxPlugins; [
        sensible
        # sensible
        copycat
        yank
        {
          plugin = tokyo-night-tmux;
          extraConfig = ''
              set -g @tokyo-night-tmux_theme storm
              set -g @tokyo-night-tmux_transparent 1
              set -g @tokyo-night-tmux_window_id_style fsquare
              set -g @tokyo-night-tmux_pane_id_style dsquare
              set -g @tokyo-night-tmux_zoom_id_style dsquare

              # Icon styles
              set -g @tokyo-night-tmux_terminal_icon 
              set -g @tokyo-night-tmux_active_terminal_icon 

              # No extra spaces between icons
              set -g @tokyo-night-tmux_window_tidy_icons 0

              set -g @tokyo-night-tmux_show_datetime 0
              set -g @tokyo-night-tmux_date_format MYD
              set -g @tokyo-night-tmux_time_format 12H

              set -g @tokyo-night-tmux_show_path 1
              set -g @tokyo-night-tmux_path_format relative # 'relative' or 'full'

              set -g @tokyo-night-tmux_show_battery_widget false
              # set -g @tokyo-night-tmux_battery_name "BAT1"  # some linux distro have 'BAT0'
              # set -g @tokyo-night-tmux_battery_low_threshold 21 # default

              set -g @tokyo-night-tmux_show_hostname 0
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        tmux-thumbs
        tmux-fzf
        fzf-tmux-url
        session-wizard
        open
        {
          plugin = better-mouse-mode;
          extraConfig = ''
            set -g @scroll-speed-num-lines-per-scroll "1"
            set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
          '';
        }
      ] ++ cfg.plugins;
      
      extraConfig = ''
        # Enable mouse support
        set -g mouse on
        
        # Set window notifications
        setw -g monitor-activity on
        set -g visual-activity on
        
        # Automatically renumber windows
        set -g renumber-windows on
        
        # Use vi keys in copy mode
        setw -g mode-keys vi
        
        # Keybindings
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        
        # Split panes using | and -
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %
        
        # Reload config
        bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
        
        # Ensure colors work properly
        set-option -sa terminal-overrides ',*:RGB'
      '';
    };
  };
}
