{ config, lib, pkgs, ... }:

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
  };
  
  # Enable editor modules
  modules.editors = {
    neovim.enable = true;
    vscode.enable = true;
  };
  
  # Common development packages
  home.packages = with pkgs; [
    # Languages and platforms
    nodejs
    python3
    rustup
    go
    
    # Build tools
    gcc
    gnumake
    cmake
    
    # Dev tools
    jq
    yq
    bat
    fd
    ripgrep
    fzf
    gh
    
    # Docker tools
    docker-compose
    lazydocker
  ];
  
  # XDG directories
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    cacheHome = "${config.home.homeDirectory}/.cache";
  };
  
  # Configure direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # Configure starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
}