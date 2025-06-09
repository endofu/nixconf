{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.modules.macos;
in
{

  options.modules.macos = {
    enable = mkEnableOption "enables macos bundle";
  };

  config = mkIf cfg.enable {

    security.pam.services.sudo_local.touchIdAuth = true;
    
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
      CustomUserPreferences = {
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Disable 'Cmd + Space' for Spotlight Search
            "64" = {
              enabled = false;
            };
            # Disable 'Cmd + Alt + Space' for Finder search window
            "65" = {
              enabled = false;
            };
          };
        };
      };
    };
    # system.activationScripts.postUserActivation.text = ''
    #   # Following line should allow us to avoid a logout/login cycle when changing settings
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';
  };
}
