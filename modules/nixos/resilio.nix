{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.resilio;
in
{
  config = mkIf cfg.enable {
    services.resilio = {
      enable = true;
      deviceName = cfg.deviceName;
      listeningPort = cfg.listeningPort;
      enableWebUI = cfg.webUI.enable;
      httpListenAddr = cfg.webUI.listenAddr;
      httpListenPort = cfg.webUI.port;
      httpLogin = cfg.webUI.login;
      httpPass = cfg.webUI.password;
      storagePath = if cfg.storagePath != null then cfg.storagePath else "/var/lib/resilio-sync";
    };

    systemd.services.resilio.serviceConfig = mkIf (cfg.user != null) {
      User = mkForce cfg.user;
      Group = mkForce (if cfg.group != null then cfg.group else "users");
    };

    systemd.tmpfiles.rules = mkIf (cfg.user != null) [
      "d '${if cfg.storagePath != null then cfg.storagePath else "/var/lib/resilio-sync"}' 0700 ${cfg.user} ${if cfg.group != null then cfg.group else "users"} - -"
      "Z '${if cfg.storagePath != null then cfg.storagePath else "/var/lib/resilio-sync"}' 0700 ${cfg.user} ${if cfg.group != null then cfg.group else "users"} - -"
    ];
  };
}
