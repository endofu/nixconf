{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.modules.macos-apps;
in
{

  options.modules.macos-apps = {
    enable = mkEnableOption "enables macos-apps bundle";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      discord
      zoom-us
      raycast
    ];
  };
}
