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
    opencode.enable = true;
    gemini.enable = true;
    ghostty.enable = true;

    mosquitto = {
      enable = false;
      mqttui.enable = false;
    };

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
        podman = false;
      };
    };
    networking = {
      enable = true;
      enableWireless = false;
      enableVPN = false;
      firewall = {
        enable = true;
        allowedTCPPorts = [
          22
        ];
        allowedUDPPorts = [ ];
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
    xfce4-pulseaudio-plugin
    autorandr
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  sops.defaultSopsFile = ./../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/sparta/.config/sops/age/keys.txt";

  sops.secrets.github_token = {
    owner = "sparta";
  };

  programs.bash.shellInit = ''
    export GITHUB_TOKEN="$(cat /run/secrets/github_token)"
  '';
}
