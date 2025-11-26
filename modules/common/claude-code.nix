{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.claude-code;
in
{
  options.modules.claude-code = {
    enable = mkEnableOption "claude-code configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      claude-code
      claude-monitor
    ];
  };
}
