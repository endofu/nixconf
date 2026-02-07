{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.mosquitto;

  mosquittoConf = pkgs.writeText "mosquitto.conf" ''
    listener 1883 0.0.0.0
    allow_anonymous true
  '';
in
{
  # Darwin-specific mosquitto configuration
  config = mkIf cfg.enable {
    homebrew.brews = [ "mosquitto" ];

    launchd.user.agents.mosquitto = {
      serviceConfig = {
        Label = "org.eclipse.mosquitto";
        ProgramArguments = [
          "/opt/homebrew/opt/mosquitto/sbin/mosquitto"
          "-c"
          "${mosquittoConf}"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/mosquitto.log";
        StandardErrorPath = "/tmp/mosquitto.error.log";
      };
    };
  };
}
