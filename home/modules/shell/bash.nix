{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.bash;
in {
  options.modules.shell.bash = {
    enable = mkEnableOption "bash configuration";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      
      historyControl = [
        "erasedups"
        "ignoredups"
        "ignorespace"
      ];
      
      historyFileSize = 100000;
      historySize = 10000;
      
      shellAliases = {
      };

      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      
      initExtra = ''
        # Additional bash configuration
        
        # Prompt
        if [ "$TERM" != "dumb" ]; then
          export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        fi
        
        # Custom functions
        function mkcd() {
          mkdir -p "$1" && cd "$1"
        }
        
        # Load local configuration if it exists
        if [ -f ~/.bashrc.local ]; then
          source ~/.bashrc.local
        fi
      '';
      
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "less";
        LESS = "-R";
      };
    };
    
    # Ensure profile is set up
    home.file.".profile".text = ''
      # ~/.profile: executed by the command interpreter for login shells.
      
      # Set PATH so it includes user's private bin if it exists
      if [ -d "$HOME/bin" ] ; then
          PATH="$HOME/bin:$PATH"
      fi
      
      if [ -d "$HOME/.local/bin" ] ; then
          PATH="$HOME/.local/bin:$PATH"
      fi
      
      # Load bashrc for interactive shells
      if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
          source "$HOME/.bashrc"
      fi
    '';
  };
}
