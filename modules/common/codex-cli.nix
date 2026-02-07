{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.codex-cli;
in
{
  options.modules.codex-cli = {
    enable = mkEnableOption "codex-cli configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      codex
    ];
  };
}
