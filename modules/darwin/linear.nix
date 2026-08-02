{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.linear;
in
{
  options.modules.linear = {
    enable = mkEnableOption "enables linear bundle";
  };

  # Darwin-specific codex configuration
  config = mkIf cfg.enable {
    homebrew = {
      casks = [ "linear" ];
      taps = [
        {
          name = "schpet/tap";
          trusted = true;
        }
      ];
      brews = [
        "schpet/tap/linear"
      ];
    };
  };
}
