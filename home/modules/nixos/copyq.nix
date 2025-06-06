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
