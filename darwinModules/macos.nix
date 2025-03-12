{ lib, config, ... }:
{

  options = {
    macos.enable = lib.mkEnableOption "enables macos bundle";
  };

  config = lib.mkIf config.macos.enable {

    system.defaults = {
      dock = {
        autohide = true;
        tilesize = 24;
        persistent-apps = [ ];
        launchanim = false;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.1;
        wvous-bl-corner = 13;
      };
      finder = {
        NewWindowTarget = "Home";
        FXPreferredViewStyle = "Nlsv";
        AppleShowAllFiles = true;
        _FXSortFoldersFirst = true;
        FXDefaultSearchScope = "SCcf";
        _FXShowPosixPathInTitle = true;
      };
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };
      trackpad = {
        TrackpadRightClick = true;
      };
      controlcenter = {
        AirDrop = true;
        BatteryShowPercentage = true;
        Bluetooth = true;
        Display = true;
        Sound = true;
      };
    };
  };
}
