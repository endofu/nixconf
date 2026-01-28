{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.antigravity;
in
{
  options.modules.antigravity = {
    enable = mkEnableOption "antigravity configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      antigravity
      google-chrome
    ];
  };
}
