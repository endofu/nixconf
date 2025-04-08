{ config, pkgs, lib, ... }:

{
  # Include modules by enabling them
  modules = {
    apps.enable = true;
    networking.enable = true;
  };

  # Machine-specific configurations
  networking.hostName = "macbook";
  system.defaults.trackpad.Clicking = true;
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;

  # Define users and their home-manager configurations
  home-manager.users = {
    alice = import ../../../home/users/alice/darwin.nix;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    # macOS-specific packages
    mas
    m-cli
  ];

  # macOS-specific services
  services.yabai.enable = false;  # Window manager for macOS
  services.skhd.enable = false;   # Hotkey daemon for macOS
}