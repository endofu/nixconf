{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.desktop.obsidian;
in
{
  options.modules.desktop.obsidian = {
    enable = mkEnableOption "obsidian configuration";
  };

  config = mkIf cfg.enable {
    programs = {
      obsidian = {
        enable = true;
      };
    };
  };
}
