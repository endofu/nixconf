{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.nixos.copyq;
in
{
  options.modules.nixos.copyq = {
    enable = mkEnableOption "copyq configuration";

  };

  config = mkIf cfg.enable {

    services = {
      copyq = {
        enable = true;
      };
    };
  };
}
