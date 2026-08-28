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
        extraFlags = [ "--force" ];
      };
      # taps = [ "sst/tap" ];
      brews = [
        # "opencode"
        # "mas"
      ];
      casks = [
        # Basic apps
        "zen"
        # "dropbox"
        "ticktick"
        "teamviewer"
        "anydesk"
        "rustdesk"
        # "displaylink"
        "figma"
        "balenaetcher"
        "vlc"
        "antigravity"
        # "raspberry-pi-imager"
        # Dev tools
        "syntax-highlight"
        # "claude"
        "elgato-studio"
      ];
      masApps = {
        "Paste - Endless Clipboard" = 967805235;
      };
    };

    # Add Homebrew binaries to PATH
    programs.zsh.shellInit = ''
      if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    '';

  };
}
