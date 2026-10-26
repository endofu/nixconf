{ config, lib, ... }:

with lib;

let
  cfg = config.modules.shell.zsh;
in
{
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
      dotDir = "${config.xdg.configHome}/zsh";
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

      initContent = ''
        # Increase file descriptor limit for Nix/Git cache operations
        ulimit -n 8192 2>/dev/null || true
      '';

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
    # Link system terminfo to ~/.terminfo so that macOS /bin/zsh and curses
    # can find modern terminal definitions (like xterm-ghostty) on startup over SSH
    home.file.".terminfo".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/terminfo";
  };
}
