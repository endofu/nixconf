{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.code-agents;
in
{
  options.modules.code-agents = {
    enable = mkEnableOption "code-agents configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      claude-code
      codex
      opencode
    ];
  };
}
