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

    system.startup.chime = false;

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    system.defaults = {
      dock = {
        autohide = true;
        tilesize = 24;
        persistent-apps = [ ];
        static-only = true;
        launchanim = false;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.1;
        expose-animation-duration = 0.01;
        wvous-bl-corner = 13;

        appswitcher-all-displays = true;

      };
      finder = {
        NewWindowTarget = "Home";
        FXPreferredViewStyle = "Nlsv";
        AppleShowAllFiles = true;
        _FXSortFoldersFirst = true;
        FXDefaultSearchScope = "SCcf";
        _FXShowPosixPathInTitle = true;
        ShowExternalHardDrivesOnDesktop = false;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSAutomaticWindowAnimationsEnabled = false;
        NSTableViewDefaultSizeMode = 1;
        NSUseAnimatedFocusRing = false;
        NSWindowResizeTime = 0.1;
        "com.apple.keyboard.fnState" = true;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.springing.delay" = 0.1;
        "com.apple.springing.enabled" = true;
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;

      };
      trackpad = {
        TrackpadRightClick = true;
      };
      universalaccess = {
        closeViewScrollWheelToggle = true;
        reduceMotion = true;
      };
      WindowManager = {
        StandardHideDesktopIcons = true;
      };
      controlcenter = {
        AirDrop = true;
        BatteryShowPercentage = true;
        Bluetooth = true;
        Display = true;
        Sound = true;
      };
      ".GlobalPreferences" = {
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Submarine.aiff";
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
