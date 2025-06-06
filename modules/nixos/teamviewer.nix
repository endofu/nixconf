{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.teamviewer;
in
{
  options.modules.teamviewer = {
    enable = mkEnableOption "teamviewer configuration";
  };

  config = mkIf cfg.enable {
    services.teamviewer.enable = true;
  };
}
