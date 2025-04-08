{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.utilities;
in {
  options.modules.shell.utilities = {
    enable = mkEnableOption "shell utilities";
    
    enableFzf = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fzf for fuzzy finding";
    };
    
    enableExa = mkOption {
      type = types.bool;
      default = true;
      description = "Enable exa as ls replacement";
    };
    
    enableBat = mkOption {
      type = types.bool;
      default = true;
      description = "Enable bat as cat replacement";
    };
    
    enableRipgrep = mkOption {
      type = types.bool;
      default = true;
      description = "Enable ripgrep as grep replacement";
    };
    
    enableFd = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fd as find replacement";
    };
    
    enableHtop = mkOption {
      type = types.bool;
      default = true;
      description = "Enable htop as top replacement";
    };
  };

  config = mkIf cfg.enable {
    # Install shell utilities
    home.packages = with pkgs; [
      # Basic utilities
      coreutils
      gnused
      gawk
      gnugrep
      findutils
      which
      file
      tree
      ncdu
      
      # Conditionally enabled replacements
    ] ++ optionals cfg.enableFzf [ fzf ]
      ++ optionals cfg.enableExa [ eza ]
      ++ optionals cfg.enableBat [ bat ]
      ++ optionals cfg.enableRipgrep [ ripgrep ]
      ++ optionals cfg.enableFd [ fd ]
      ++ optionals cfg.enableHtop [ htop ];
    
    # Configure fzf
    programs.fzf = mkIf cfg.enableFzf {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      enableBashIntegration = config.programs.bash.enable;
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [
        "--preview 'bat --style=full  --theme=DarkNeon --color=always --line-range :500 {}'"
      ];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [
        "--preview 'tree -C {} | head -200'"
      ];
      tmux = {
        enableShellIntegration = true;
      };
#       defaultCommand = "fd --type f --hidden --exclude .git";
#       defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];
    };
    
    # Configure bat
    programs.bat = mkIf cfg.enableBat {
      enable = true;
      config = {
        theme = "Dracula";
        style = "plain";
      };
    };
    
    # Set up shell aliases for the replacement tools
    home.shellAliases = mkMerge [
      (mkIf cfg.enableExa {
        ls = "eza";
        ll = "eza -la";
        la = "eza -a";
        lt = "eza -T";
        l = "eza -F";
      })
      
      (mkIf cfg.enableBat {
        cat = "bat";
      })
      
      (mkIf cfg.enableRipgrep {
        grep = "rg";
      })
      
      (mkIf cfg.enableFd {
        find = "fd";
      })
      
      (mkIf cfg.enableHtop {
        top = "htop";
      })
    ];
  };
}
