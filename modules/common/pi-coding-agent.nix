{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.pi-coding-agent;
in
{
  options.modules.pi-coding-agent = {
    enable = mkEnableOption "pi-coding-agent configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pi-coding-agent
    ];
  };
}
