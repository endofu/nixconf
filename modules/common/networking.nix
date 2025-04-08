{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.networking;
in {
  options.modules.networking = {
    enable = mkEnableOption "networking configuration";
    
    enableWireless = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable wireless networking";
    };
    
    enableVPN = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable VPN support";
    };
    
    firewall = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable the firewall";
      };
      
      allowedTCPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "List of allowed TCP ports";
      };
      
      allowedUDPPorts = mkOption {
        type = types.listOf types.port;
        default = [];
        description = "List of allowed UDP ports";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && pkgs.stdenv.isLinux) {
      # NixOS-specific networking configuration
      networking = {
        networkmanager = {
          enable = cfg.enableWireless;
          wifi.backend = "iwd";
        };
        
        wireless = {
          enable = !config.networking.networkmanager.enable && cfg.enableWireless;
          iwd.enable = config.networking.networkmanager.enable && cfg.enableWireless;
        };
        
        firewall = {
          enable = cfg.firewall.enable;
          allowedTCPPorts = cfg.firewall.allowedTCPPorts;
          allowedUDPPorts = cfg.firewall.allowedUDPPorts;
        };
      };
      
      # VPN configuration (if enabled)
      services.tailscale.enable = cfg.enableVPN;
      services.openvpn.servers = mkIf cfg.enableVPN {
        myVPN = {
          config = "config /etc/openvpn/client/myVPN.conf";
          autoStart = false;
        };
      };
      
      # Common networking packages
      environment.systemPackages = with pkgs; [
        dnsutils
        nmap
        wireshark
        iperf
        mtr
        ipcalc
      ] ++ optionals cfg.enableVPN [
        tailscale
        openvpn
      ];
    })
    
    (mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
      # Darwin-specific networking configuration
      networking.dns = [ "1.1.1.1" "8.8.8.8" ];
      
      # Common networking packages for macOS
      environment.systemPackages = with pkgs; [
        dnsutils
        nmap
        wireshark
        iperf
        mtr
        ipcalc
      ] ++ optionals cfg.enableVPN [
        tailscale
        openvpn
      ];
    })
  ];
}