{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.codex;
in
{
  options.modules.codex = {
    enable = mkEnableOption "enables codex bundle";
  };

  # Darwin-specific codex configuration
  config = mkIf cfg.enable {
    homebrew.casks = [ "codex-app" ];
  };
}
