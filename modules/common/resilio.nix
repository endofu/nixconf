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
  options.modules.resilio = {
    enable = mkEnableOption "Resilio Sync";
    deviceName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "Device name as it will appear in Resilio Sync";
    };
    listeningPort = mkOption {
      type = types.int;
      default = 0;
      description = "Listening port for Resilio Sync (0 for random)";
    };
    webUI = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the Web UI";
      };
      listenAddr = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address for the Web UI to listen on";
      };
      port = mkOption {
        type = types.int;
        default = 8888;
        description = "Port for the Web UI";
      };
    };
  };
}
