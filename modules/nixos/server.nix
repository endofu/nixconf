{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.server;
in {
  options.modules.server = {
    enable = mkEnableOption "server configuration";
    
    sshd = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable SSH daemon";
      };
      
      permitRootLogin = mkOption {
        type = types.enum [ "yes" "no" "prohibit-password" ];
        default = "prohibit-password";
        description = "Whether to allow root login through SSH";
      };
      
      passwordAuthentication = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable password authentication";
      };
    };
    
    services = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable common server services";
      };
      
      nginx = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Nginx web server";
      };
      
      postgresql = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable PostgreSQL database";
      };
      
      docker = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Docker";
      };
    };
  };

  config = mkIf cfg.enable {
    # SSH daemon configuration
    services.openssh = mkIf cfg.sshd.enable {
      enable = true;
      permitRootLogin = cfg.sshd.permitRootLogin;
      passwordAuthentication = cfg.sshd.passwordAuthentication;
      kbdInteractiveAuthentication = cfg.sshd.passwordAuthentication;
      
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        PermitTunnel no
        AllowAgentForwarding yes
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };
    
    # Firewall configuration for SSH
    networking.firewall = mkIf cfg.sshd.enable {
      allowedTCPPorts = [ 22 ];
    };
    
    # Nginx web server
    services.nginx = mkIf cfg.services.nginx {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
    
    # PostgreSQL database
    services.postgresql = mkIf cfg.services.postgresql {
      enable = true;
      package = pkgs.postgresql_14;
      enableTCPIP = false;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      settings = {
        log_destination = "stderr";
        logging_collector = true;
        log_directory = "/var/log/postgresql";
      };
    };
    
    # Docker
    virtualisation.docker = mkIf cfg.services.docker {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    
    # Common server packages
    environment.systemPackages = with pkgs; [
      htop
      iotop
      iftop
      ncdu
      lsof
      tmux
      rsync
      rclone
#       restic
#       fail2ban
    ] ++ optionals cfg.services.nginx [
      nginx
    ] ++ optionals cfg.services.postgresql [
      postgresql_14
    ] ++ optionals cfg.services.docker [
      docker-compose
    ];
    
    # Server-specific settings
#     boot.kernel.sysctl = {
#       "vm.swappiness" = 10;
#       "fs.file-max" = 100000;
#       "net.core.somaxconn" = 1024;
#     };
  };
}
