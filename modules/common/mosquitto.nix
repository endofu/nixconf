{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.mosquitto;
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

  # mqttui can be installed independently (cross-platform)
  config = mkIf cfg.mqttui.enable {
    environment.systemPackages = with pkgs; [
      mqttui
    ];
  };
}
