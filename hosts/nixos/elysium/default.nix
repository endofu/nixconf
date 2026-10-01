{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Hardware-specific configuration
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";

  # Binary cache for t2linux pre-built kernel (avoids compiling kernel locally)
  nix.settings = {
    extra-substituters = [ "https://cache.soopy.moe" ];
    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
    ];
  };

  # Apple T2 hardware options
  hardware.apple-t2 = {
    enableIGPU = false; # Set to true to force Intel iGPU on dual-GPU models
    firmware.enable = true; # Declarative Wi-Fi & Bluetooth firmware fetched from Apple recovery
  };

  # Touch Bar emulation (F1-F12 keys, media controls)
  hardware.apple.touchBar.enable = true;

  # Include modules by enabling them
  modules = {
    basics.enable = true;
    claude-code.enable = true;
    antigravity = {
      enable = true;
      cli.enable = true;
    };

    desktop = {
      enable = true;
      windowManager = "gnome";
    };
    fonts.enable = true;
    tailscale.enable = true;
    opencode.enable = true;
    ghostty.enable = true;

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

    networking = {
      enable = true;
      enableWireless = true;
      enableVPN = false;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 ];
        allowedUDPPorts = [ ];
      };
    };
  };

  # Bootloader (systemd-boot on Apple EFI partition)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elysium";

  # Define users and their home-manager configurations
  users.users.elysium = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "podman"
    ];
  };

  home-manager.users = {
    elysium = import ../../../home/users/elysium;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    cifs-utils
    autorandr
    brightnessctl
  ];

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

  sops.defaultSopsFile = ./../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/elysium/.config/sops/age/keys.txt";

  sops.secrets.gemini_api_key = {
    owner = "elysium";
  };
  sops.secrets.anthropic_api_key = {
    owner = "elysium";
  };
  sops.secrets.github_token = {
    owner = "elysium";
  };
  programs.bash.shellInit = ''
    [ -f /run/secrets/gemini_api_key ] && export GEMINI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    [ -f /run/secrets/gemini_api_key ] && export GOOGLE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    [ -f /run/secrets/gemini_api_key ] && export GOOGLE_GENERATIVE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    [ -f /run/secrets/anthropic_api_key ] && export ANTHROPIC_API_KEY="$(cat /run/secrets/anthropic_api_key)"
    [ -f /run/secrets/github_token ] && export GITHUB_TOKEN="$(cat /run/secrets/github_token)"
  '';
}
