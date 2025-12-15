{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.vnc;
in
{
  options.modules.vnc = {
    enable = mkEnableOption "vnc configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      realvnc-vnc-viewer
    ];
  };
}
