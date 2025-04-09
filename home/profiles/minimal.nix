{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/shell
  ];
  
  # Enable core shell modules
  modules.shell = {
    zsh.enable = true;
    bash.enable = true;
    utilities = {
      enable = true;
      # Disable some of the heavier utilities
      enableFzf = false;
      enableExa = true;
      enableBat = false;
      enableRipgrep = false;
      enableFd = false;
      enableHtop = true;
    };
    git.enable = true;
    tmux.enable = false;
  };
  
  # Minimal set of packages
  home.packages = with pkgs; [
    curl
    wget
    vim
    unzip
    htop
  ];
  
  # Simple GUI programs if this is a desktop
  programs.firefox.enable = pkgs.stdenv.isLinux;
  
  # XDG directories
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    cacheHome = "${config.home.homeDirectory}/.cache";
  };
}