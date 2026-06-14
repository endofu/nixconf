{
  config,
  lib,
  pkgs,
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
      storagePath = "/home/arcadia/.rslsync";
    };

    # Ensure rslsync package is available
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "resilio-sync"
    ];
  };
}
