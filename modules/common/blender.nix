{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.blender;
in
{
  options.modules.blender = {
    enable = mkEnableOption "blender configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      blender
    ];
  };
}
