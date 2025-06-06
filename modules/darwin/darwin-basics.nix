{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.modules.darwin-basics;
in
{

  options.modules.darwin-basics = {
    enable = mkEnableOption "enables darwin-basics bundle";
  };

  config = mkIf cfg.enable {

    security.pam.services.sudo_local.touchIdAuth = true;

  };
}
