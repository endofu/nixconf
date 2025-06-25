{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.podman;
in
{

  options.modules.podman = {
    enable = mkEnableOption "enables podman bundle";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      podman
      podman-compose
      podman-tui
    ];
  };
}
