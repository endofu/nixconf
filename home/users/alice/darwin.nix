{ config, lib, pkgs, ... }:

{
  imports = [
    ./default.nix
  ];

  # Darwin-specific home-manager configuration
  home.packages = with pkgs; [
    # macOS-specific packages
    m-cli # Swiss Army Knife for macOS
    
    # GNU utilities to replace BSD variants
    gnused
    gnutar
    coreutils
    findutils
    
    # Development tools for macOS
    cocoapods
  ];
  
  # Mac-specific configurations
  targets.darwin = {
    currentHostDefaults = {
      "com.apple.controlcenter" = {
        BatteryShowPercentage = true;
      };
      
      "com.apple.Finder" = {
        ShowPathbar = true;
        ShowStatusBar = true;
        FXPreferredViewStyle = "clmv";
        FXDefaultSearchScope = "SCcf";
        AppleShowAllFiles = true;
      };
      
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      
      "com.apple.dock" = {
        autohide = true;
        show-recents = false;
        tilesize = 48;
        minimize-to-application = true;
      };
      
      "com.apple.screencapture" = {
        location = "${config.home.homeDirectory}/Pictures/Screenshots";
        type = "png";
      };
    };
    
    # Link applications to ~/Applications
    search = "both";
    defaults = {
      CustomUserPreferences = {
        # Global domain
        NSGlobalDomain = {
          AppleKeyboardUIMode = 3; # Full keyboard access
          AppleShowAllExtensions = true;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
        };
      };
    };
  };
  
  # Mac-specific program configurations
  programs = {
    # Terminal emulator configuration
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          decorations = "buttonless";
        };
        
        font = {
          normal = {
            family = "FiraCode Nerd Font";
            style = "Regular";
          };
          size = 14.0;
        };
        
        colors = {
          # Dracula theme
          primary = {
            background = "#282a36";
            foreground = "#f8f8f2";
          };
          
          cursor = {
            text = "#282a36";
            cursor = "#f8f8f2";
          };
          
          normal = {
            black = "#000000";
            red = "#ff5555";
            green = "#50fa7b";
            yellow = "#f1fa8c";
            blue = "#bd93f9";
            magenta = "#ff79c6";
            cyan = "#8be9fd";
            white = "#bbbbbb";
          };
          
          bright = {
            black = "#555555";
            red = "#ff5555";
            green = "#50fa7b";
            yellow = "#f1fa8c";
            blue = "#bd93f9";
            magenta = "#ff79c6";
            cyan = "#8be9fd";
            white = "#ffffff";
          };
        };
      };
    };
    
    # Karabiner key remapping
    karabiner = {
      enable = true;
      goku = {
        enable = true;
        config = {
          main = {
            spacebar = {
              alone = "spacebar";
              held = "left_shift";
            };
            
            # Caps Lock to Escape when pressed alone, Control when held
            caps_lock = {
              alone = "escape";
              held = "left_control";
            };
          };
        };
      };
    };
  };
}