{
  pkgs,
  inputs,
  lib,
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
      windowManager = "xfce";
    };
    fonts.enable = true;
    teamviewer.enable = false;
    llm = {
      enable = false;
      ollama = {
        enable = false;
      };
    };
    vnc.enable = false;
    rustdesk = {
      enable = true;
      service.enable = true;
    };
    tailscale.enable = true;
    opencode.enable = true;
    ghostty.enable = true;
    resilio = {
      enable = true;
      user = "delos";
      storagePath = "/home/delos/.rslsync";
      webUI = {
        enable = true;
        listenAddr = "0.0.0.0";
        port = 8888;
      };
    };
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
          8888
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
    linger = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman" # TODO: move this to module
    ];
  };

  # Auto-start podman-compose projects on boot without requiring login
  systemd.services.chirpstack-docker = {
    description = "ChirpStack Docker Compose Service";
    after = [
      "network-online.target"
      "user@1000.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "user@1000.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      "/run/wrappers"
      "/run/current-system/sw"
      pkgs.podman
      pkgs.podman-compose
      pkgs.coreutils
    ];
    environment = {
      HOME = "/home/delos";
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "delos";
      WorkingDirectory = "/home/delos/Code/chirpstack-docker";
      ExecStart = "${pkgs.podman-compose}/bin/podman-compose up -d";
      ExecStop = "${pkgs.podman-compose}/bin/podman-compose down";
      TimeoutStartSec = "300";
    };
  };

  systemd.services.evacuated-sim-backend = {
    description = "Evacuated Sim Backend Compose Service";
    after = [
      "network-online.target"
      "user@1000.service"
      "chirpstack-docker.service"
    ];
    wants = [
      "network-online.target"
      "chirpstack-docker.service"
    ];
    requires = [
      "user@1000.service"
    ];
    wantedBy = [ "multi-user.target" ];
    path = [
      "/run/wrappers"
      "/run/current-system/sw"
      pkgs.podman
      pkgs.podman-compose
      pkgs.coreutils
    ];
    environment = {
      HOME = "/home/delos";
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "delos";
      WorkingDirectory = "/home/delos/Code/evacuated-sim-backend";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
      ExecStart = "${pkgs.podman-compose}/bin/podman-compose up -d";
      ExecStop = "${pkgs.podman-compose}/bin/podman-compose down";
      TimeoutStartSec = "300";
    };
  };

  # Completely disable systemd sleep/suspend/hibernation targets
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Tell systemd sleep to disallow any sleep/suspend operations
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

  # Prevent logind from sleeping on idle, lid close, or power/sleep keys
  services.logind.settings.Login = {
    IdleAction = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # Prevent Wi-Fi from going into power save mode
  networking.networkmanager.wifi.powersave = false;

  home-manager.users = {
    delos = import ../../../home/users/delos;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    # Server-specific packages
    cifs-utils
    autorandr
    xfce4-pulseaudio-plugin
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
