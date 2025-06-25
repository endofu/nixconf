{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.homebrew;
in
{
  options.modules.homebrew = {
    enable = mkEnableOption "macOS Homebrew applications";
  };

  config = mkIf cfg.enable {

    # Common packages for all macOS setups
    environment.systemPackages = [
    ];

    # Homebrew configuration
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };
      taps = [ ];
      brews = [
        "mas"
      ];
      casks = [
        # Basic apps
        "zen-browser"
        "dropbox"
        "ticktick"
        "teamviewer"
        "anydesk"
        "displaylink"
        "figma"
        "linear-linear"

        # Dev tools
        "syntax-highlight"
      ];
      masApps = {
        "Paste - Endless Clipboard" = 967805235;
      };
    };

  };
}
