{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.resilio;
  user = config.system.primaryUser;
  storagePath = "/Users/${user}/.rslsync";
  logDir = "/Users/${user}/Library/Logs";
  
  syncConfig = pkgs.writeText "sync.conf" (builtins.toJSON {
    device_name = cfg.deviceName;
    storage_path = storagePath;
    listening_port = cfg.listeningPort;
    check_for_updates = false;
    use_upnp = true;
    webui = if cfg.webUI.enable then {
      listen = "${cfg.webUI.listenAddr}:${toString cfg.webUI.port}";
    } else null;
  });
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.resilio-sync ];

    launchd.user.agents.resilio-sync = {
      command = "${pkgs.resilio-sync}/bin/rslsync --nodaemon --config ${syncConfig}";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${logDir}/resilio-sync.out.log";
        StandardErrorPath = "${logDir}/resilio-sync.err.log";
      };
    };

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "resilio-sync"
    ];

    # Ensure storage path exists
    system.activationScripts.extraActivation.text = ''
      echo "ensuring resilio storage path exists..."
      mkdir -p ${storagePath}
      chown ${user} ${storagePath}
    '';
  };
}
