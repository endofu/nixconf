# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  nixpkgs.config.allowUnfree = true;

  # Include modules by enabling them
  modules = {
    basics.enable = true;
    claude-code.enable = true;

    desktop = {
      enable = true;
      windowManager = "xfce";
    };
    fonts.enable = true;
    teamviewer.enable = false;
    llm.enable = false;
    tailscale.enable = true;

    server = {
      enable = true;
      sshd = {
        enable = true;
        permitRootLogin = "no";
        passwordAuthentication = false;
      };
      services = {
        enable = true;
        nginx = false;
        postgresql = false;
        docker = false;
        podman = true;
      };
    };
    mosquitto = {
      enable = true;
    };
    networking = {
      enable = true;
      enableWireless = true;
      enableVPN = false;
      firewall = {
        enable = true;
        allowedTCPPorts = [
          22
          80
          8080
          443
          5173
          5174
        ];
        allowedUDPPorts = [ 8001 ];
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sparta"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Define users and their home-manager configurations
  users.users.sparta = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman" # TODO: move this to module
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

  home-manager.users = {
    sparta = import ../../../home/users/sparta;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xfce.xfce4-pulseaudio-plugin
    autorandr
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
