{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ffmpeg;
in
{
  options.modules.ffmpeg = {
    enable = mkEnableOption "ffmpeg configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      ffmpeg-full
    ];
  };
}
