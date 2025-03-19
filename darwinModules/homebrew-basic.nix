{ lib, config, ... }: {

  options = {
    homebrew-basic.enable =
      lib.mkEnableOption "enables homebrew-basic bundle";
  };

  config = lib.mkIf config.homebrew-basic.enable {

    homebrew = {
      casks = [
        "zen-browser"
        "dropbox"
        "ticktick"
        "teamviewer"
      ];
      masApps = {
        "Paste - Endless Clipboard" = 967805235;
      };
    };

  };
}
