{
  lib,
  config,
  pkgs,
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

    environment.systemPackages = [
      pkgs.reattach-to-user-namespace
    ];
  };
}
