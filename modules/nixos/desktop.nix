{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkEnableOption "desktop environment";
    
    windowManager = mkOption {
      type = types.enum [ "i3" "sway" "gnome" "kde" ];
      default = "gnome";
      description = "Window manager to use";
    };
  };

  config = mkIf cfg.enable {
    # Desktop configuration based on the selected window manager
    services.xserver = {
      enable = true;
      
      displayManager.gdm.enable = cfg.windowManager == "gnome";
      desktopManager.gnome.enable = cfg.windowManager == "gnome";
      
      displayManager.sddm.enable = cfg.windowManager == "kde";
      desktopManager.plasma5.enable = cfg.windowManager == "kde";
      
      windowManager = {
        i3.enable = cfg.windowManager == "i3";
      };
    };
    
    programs.sway.enable = cfg.windowManager == "sway";
    
    # Common packages for all desktop setups
    environment.systemPackages = with pkgs; [
      firefox
      alacritty
      gnome.gnome-tweaks
      gnome.dconf-editor
      networkmanagerapplet
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];

    # Font configuration
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        fira-code
        fira-code-symbols
      ];
    };

    # Sound configuration
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Enable Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Basic desktop services
    services = {
      printing.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      blueman.enable = true;
    };
  };
}