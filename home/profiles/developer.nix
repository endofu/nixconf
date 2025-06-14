{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/shell
    ../modules/editors
  ];

  # Enable shell modules
  modules.shell = {
    zsh.enable = true;
    bash.enable = true;
    utilities.enable = true;
    git.enable = true;
    tmux.enable = true;
    wezterm.enable = true;
    lazygit.enable = true;
  };

  # Enable editor modules
  modules.editors = {
    neovim.enable = true;
    vscode.enable = false;
  };

  home.packages = with pkgs; [
    # Build tools
    #     gcc
    #     gnumake
    #     cmake

    # Dev tools
    jq
    yq
    bat
    fd
    ripgrep
    fzf
    gh
    nixd
    nil
    nixfmt-rfc-style
    tree
    eza
    lsd
    zoxide
    dust
    duf
    ncdu
    btop
    htop
    #     nowplaying-cli # this is needed for the tokyo-night-tmux plugin

    # Docker tools
    #     docker-compose
    #     lazydocker
  ];

  # XDG directories
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    cacheHome = "${config.home.homeDirectory}/.cache";
  };

  # Configure direnv
  #   programs.direnv = {
  #     enable = true;
  #     nix-direnv.enable = true;
  #   };
  #
  # Configure starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
}
