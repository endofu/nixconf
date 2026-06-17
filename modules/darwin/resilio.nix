{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.resilio;
  user = if cfg.user != null then cfg.user else config.system.primaryUser;
  storagePath = if cfg.storagePath != null then cfg.storagePath else "/Users/${user}/.rslsync";
  logDir = "/Users/${user}/Library/Logs";
  
  syncConfig = pkgs.writeText "sync.conf" (builtins.toJSON {
    device_name = cfg.deviceName;
    storage_path = storagePath;
    listening_port = cfg.listeningPort;
    check_for_updates = false;
    use_upnp = true;
    use_gui = false;
    webui = if cfg.webUI.enable then {
      listen = "${cfg.webUI.listenAddr}:${toString cfg.webUI.port}";
    } else null;
  });
in
{
  config = mkIf cfg.enable {
    # Install via Homebrew Cask since it's not in nixpkgs for Darwin
    homebrew.casks = [ "resilio-sync" ];

    launchd.user.agents.resilio-sync = {
      serviceConfig = {
        ProgramArguments = [
          "/Applications/Resilio Sync.app/Contents/MacOS/Resilio Sync"
          "--config"
          "${syncConfig}"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${logDir}/resilio-sync.out.log";
        StandardErrorPath = "${logDir}/resilio-sync.err.log";
      };
    };

    # Ensure storage path exists
    system.activationScripts.extraActivation.text = ''
      echo "ensuring resilio storage path exists..."
      mkdir -p ${storagePath}
      chown ${user} ${storagePath}
    '';
  };
}
