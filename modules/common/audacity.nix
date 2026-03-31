{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.audacity;
in
{
  options.modules.audacity = {
    enable = mkEnableOption "audacity configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      audacity
    ];
  };
}
