{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.teams;
in
{

  options.modules.teams = {
    enable = mkEnableOption "enables teams bundle";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      teams
    ];
  };
}
