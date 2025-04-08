{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.apps;
in {
  options.modules.apps = {
    enable = mkEnableOption "macOS applications";
    
    includeDevTools = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include development tools";
    };
    
    includeProductivity = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include productivity applications";
    };
    
    includeUtilities = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include utility applications";
    };
  };

  config = mkIf cfg.enable {
    # macOS-specific system defaults and settings
    system.defaults = {
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
        AppleInterfaceStyle = "Dark";
        AppleShowScrollBars = "Always";
      };
      
      dock = {
        autohide = true;
        show-recents = false;
        tilesize = 48;
      };
      
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };
    };
    
    # Basic Darwin settings
    services.nix-daemon.enable = true;
    
    # Common packages for all macOS setups
    environment.systemPackages = with pkgs; [
      # Base utilities
      coreutils
      curl
      wget
      gnupg
      
      # Conditional package sets
    ] ++ optionals cfg.includeDevTools [
      vscodium
      iterm2
      docker
    ] ++ optionals cfg.includeProductivity [
      obsidian
    ] ++ optionals cfg.includeUtilities [
      alfred
      karabiner-elements
      rectangle
    ];
    
    # Enable compatible homebrew applications
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
      };
      brews = [
        "mas"
      ];
      casks = [
        "firefox"
        "alacritty"
      ];
    };
  };
}