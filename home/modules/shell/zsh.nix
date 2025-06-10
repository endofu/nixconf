{ config, lib,  ... }:

with lib;

let
  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = mkEnableOption "zsh configuration";
    
    defaultShell = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to set zsh as the default shell";
    };
    
    enableCompletion = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable zsh completion";
    };
    
    enableSyntaxHighlighting = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable zsh syntax highlighting";
    };
    
    enableAutosuggestions = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable zsh autosuggestions";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = cfg.enableCompletion;
      autosuggestion.enable = cfg.enableAutosuggestions;
      syntaxHighlighting.enable = cfg.enableSyntaxHighlighting;
      
#       oh-my-zsh = {
#         enable = true;
#         plugins = [
#           "git"
#           "docker"
#           "docker-compose"
#           "kubectl"
#           "history"
#           "sudo"
#         ];
#       };
      
#       initExtra = ''
#         # Additional zsh configuration
#
#         # Key bindings
#         bindkey '^[[A' history-substring-search-up
#         bindkey '^[[B' history-substring-search-down
#
#         # Aliases
#         alias ls='ls --color=auto'
#         alias ll='ls -la'
#         alias la='ls -A'
#         alias l='ls -CF'
#
#         # Custom functions
#         function mkcd() {
#           mkdir -p "$1" && cd "$1"
#         }
#
#         # Load local configuration if it exists
#         if [ -f ~/.zshrc.local ]; then
#           source ~/.zshrc.local
#         fi
#       '';
      
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "less";
        LESS = "-R";
      };
      
      history = {
        size = 100000;
        save = 2000000;
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
        share = true;
      };

      shellAliases = {
        mc = "mc --nosubshell";
        ls = "lsd -al";
        lst = "lsd -al --tree";
        cat = "bat";
#         vim = "nix run ~/Code/nixconf/nvf"; # this should be referenced relatively
      };
    };
    
    # Set zsh as default shell if requested
    programs.bash.enable = mkIf cfg.defaultShell true;
    home.file.".bash_profile".text = mkIf cfg.defaultShell ''
      # Forward to .profile
      [ -f ~/.profile ] && source ~/.profile
      
      # Launch zsh if available
      if [ -z "$ZSH_VERSION" ] && command -v zsh >/dev/null; then
        exec zsh
      fi
    '';
  };
}
