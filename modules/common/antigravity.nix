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
    enable = mkEnableOption "antigravity fhs application";
    cli.enable = mkEnableOption "antigravity-cli";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        antigravity-fhs
        google-chrome
      ];
    })
    (mkIf cfg.cli.enable {
      environment.systemPackages = with pkgs; [
        antigravity-cli
      ];
    })
  ];
}
