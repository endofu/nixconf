{ pkgs, lib, config, ... }: {

  options = {
    terminal.enable =
      lib.mkEnableOption "enables terminal bundle";
  };

  config = lib.mkIf config.terminal.enable {
    environment.systemPackages = with pkgs; [
      wezterm
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
        zed-editor = {
          enable = true;
          extensions = ["nix"];
        };

        wezterm = {
          enable = true;
        };

        tmux = {
          enable = true;
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
