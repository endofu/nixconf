{ pkgs, lib, config, ... }: {

  options = {
    personal.enable =
      lib.mkEnableOption "enables personal bundle";
  };

  config = lib.mkIf config.personal.enable {

    environment.systemPackages = with pkgs; [
      obsidian
      discord
      zoom-us
      raycast
      arc-browser
      # dropbox
    ];
  };
}
