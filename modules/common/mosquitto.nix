{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.mosquitto;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  options.modules.mosquitto = {
    enable = mkEnableOption "Mosquitto MQTT broker";

    mqttui = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install mqttui terminal client";
      };
    };
  };

  config = mkMerge [
    # mqttui can be installed independently
    (mkIf cfg.mqttui.enable {
      environment.systemPackages = with pkgs; [
        mqttui
      ];
    })

    # NixOS-specific mosquitto service configuration
    (mkIf (cfg.enable && isLinux) {
      services.mosquitto = {
        enable = true;
        listeners = [
          {
            acl = [ "pattern readwrite #" ];
            omitPasswordAuth = true;
            settings.allow_anonymous = true;
          }
        ];
      };

      networking.firewall.allowedTCPPorts = [ 1883 ];
    })

    # Darwin-specific mosquitto configuration
    (mkIf (cfg.enable && isDarwin) {
      homebrew.brews = [ "mosquitto" ];

      launchd.user.agents.mosquitto = {
        serviceConfig = {
          Label = "org.eclipse.mosquitto";
          ProgramArguments = [
            "/opt/homebrew/opt/mosquitto/sbin/mosquitto"
            "-c"
            "/opt/homebrew/etc/mosquitto/mosquitto.conf"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/tmp/mosquitto.log";
          StandardErrorPath = "/tmp/mosquitto.error.log";
        };
      };
    })
  ];
}
