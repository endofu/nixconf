{ pkgs, lib, config, ... }: {

  options = {
    media.enable =
      lib.mkEnableOption "enables media bundle";
  };

  config = lib.mkIf config.media.enable {
    environment.systemPackages = with pkgs; [
      ffmpeg
    ];
  };
}
