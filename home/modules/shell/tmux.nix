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
      
      prefix = "C-a";
      baseIndex = 1;
      escapeTime = 10;
      historyLimit = 10000;
      
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        resurrect
        continuum
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-show-battery false
            set -g @dracula-show-powerline true
            set -g @dracula-show-network false
            set -g @dracula-show-left-icon session
            set -g @dracula-border-contrast true
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