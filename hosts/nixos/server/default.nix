{ config, pkgs, lib, ... }:

{
  imports = [
    # Hardware-specific configuration
    ./hardware-configuration.nix
  ];

  # Include modules by enabling them
  modules = {
    server = {
      enable = true;
      sshd = {
        enable = true;
        permitRootLogin = "no";
        passwordAuthentication = false;
      };
      services = {
        enable = true;
        nginx = true;
        postgresql = true;
        docker = true;
      };
    };
    networking = {
      enable = true;
      enableWireless = false;
      enableVPN = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 22 80 443 ];
        allowedUDPPorts = [];
      };
    };
  };

  # Machine-specific configurations
  networking.hostName = "server";
  
  # Define users and their home-manager configurations
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJqr1ylpMV5g+CtuHd8jmjh4JB6Bt6EFMCJISYTLmFqM alice@example.com"
    ];
  };
  
  home-manager.users = {
    alice = import ../../../home/users/alice/nixos.nix;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    # Server-specific packages
    borgbackup
    smartmontools
    sysstat
  ];
  
  # Configure automated backups
  services.borgbackup.jobs = {
    home = {
      paths = [ "/home" ];
      exclude = [ "*/Downloads" "*/Trash" "*/node_modules" ];
      repo = "/mnt/backup/borg-repository";
      encryption = {
        mode = "repokey";
        passCommand = "cat /etc/borg-passphrase";
      };
      compression = "auto,lzma";
      startAt = "daily";
      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 6;
      };
    };
  };
  
  # Configure monitoring
  services.prometheus = {
    enable = true;
    port = 9090;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "localhost:9100" ];
        }];
      }
    ];
  };
  
  # Configure Grafana for monitoring visualization
  services.grafana = {
    enable = true;
    domain = "grafana.server";
    port = 3000;
    addr = "127.0.0.1";
    provision = {
      enable = true;
      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://localhost:9090";
            }
          ];
        };
      };
    };
  };
  
  # Configure Nginx for proxying services
  services.nginx.virtualHosts = {
    "grafana.server" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
  };
}