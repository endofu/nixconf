{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.mosquitto;
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
          "/opt/homebrew/etc/mosquitto/mosquitto.conf"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/mosquitto.log";
        StandardErrorPath = "/tmp/mosquitto.error.log";
      };
    };
  };
}
