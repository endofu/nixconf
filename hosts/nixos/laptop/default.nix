{ config, pkgs, lib, ... }:

{
  imports = [
    # Hardware-specific configuration
    ./hardware-configuration.nix
  ];

  # Include modules by enabling them
  modules = {
    desktop = {
      enable = true;
      windowManager = "gnome";
    };
    networking.enable = true;
  };

  # Machine-specific configurations
  networking.hostName = "laptop";
  
  # Define users and their home-manager configurations
  home-manager.users = {
    alice = import ../../../home/users/alice/nixos.nix;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    # Laptop-specific packages
    powertop
    acpi
    tlp
  ];

  # System-specific services
  services.tlp.enable = true;
  services.thermald.enable = true;
}