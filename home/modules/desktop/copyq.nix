{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.desktop.copyq;
in
{
  options.modules.desktop.copyq = {
    enable = mkEnableOption "lazygit configuration";

  };

  config = mkIf cfg.enable {

    services = {
      copyq = {
        enable = true;
      };
    };
  };
}
