{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.tailscale;
in
{
  options.modules.tailscale = {
    enable = mkEnableOption "tailscale configuration";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
