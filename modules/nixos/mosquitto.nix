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
  # NixOS-specific mosquitto service configuration
  config = mkIf cfg.enable {
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
  };
}
