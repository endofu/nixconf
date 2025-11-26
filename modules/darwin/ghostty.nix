{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.ghostty;
in
{

  options.modules.ghostty = {
    enable = mkEnableOption "enables ghostty bundle";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      ghostty-bin
    ];
  };
}
