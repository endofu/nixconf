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
    teamviewer.enable = false;
    llm = {
      enable = true;
      ollama = {
        enable = true;
        cuda = false;
      };
    };
    vnc.enable = false;
    tailscale.enable = true;
    opencode.enable = true;
    gemini.enable = true;
    ghostty.enable = true;
    # resilio.enable = true;
    audacity.enable = false;

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
        allowedTCPPorts = [
          22
          80
          8080
          8082
          443
        ];
        allowedUDPPorts = [ 1700 ];
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Machine-specific configurations
  networking.hostName = "delos";

  # Define users and their home-manager configurations
  users.users.delos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman" # TODO: move this to module
    ];
  };

  home-manager.users = {
    delos = import ../../../home/users/delos;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    # Server-specific packages
    cifs-utils
    autorandr
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

  sops.age.keyFile = "/home/delos/.config/sops/age/keys.txt";

  sops.secrets.gemini_api_key = {
    owner = "delos";
  };
  sops.secrets.anthropic_api_key = {
    owner = "delos";
  };
  sops.secrets.github_token = {
    owner = "delos";
  };
  programs.bash.shellInit = ''
    export GITHUB_TOKEN="$(cat /run/secrets/github_token)"
  '';
}
