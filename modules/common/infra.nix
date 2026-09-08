{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.infra;
in
{
  options.modules.infra = {
    enable = mkEnableOption "infra configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      opentofu
      scaleway-cli
    ];
  };
}
