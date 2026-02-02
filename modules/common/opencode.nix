{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.opencode;
in
{
  options.modules.opencode = {
    enable = mkEnableOption "opencode configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      opencode
      google-chrome
    ];
  };
}
