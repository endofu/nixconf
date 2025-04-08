{ config, pkgs, lib, ... }:

{
  # Include modules by enabling them
  modules = {
    apps = {
      enable = true;
      includeDevTools = true;
      includeProductivity = true;
      includeUtilities = true;
    };
    networking = {
      enable = true;
      enableWireless = true;
      enableVPN = true;
    };
  };

  # Machine-specific configurations
  networking.hostName = "mac-mini";
  networking.computerName = "Alice's Mac Mini";
  system.defaults.finder.CreateDesktop = false;  # Hide desktop icons
  
  # Define users and their home-manager configurations
  home-manager.users = {
    alice = import ../../../home/users/alice/darwin.nix;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    # Mac-specific packages
    mas
    
    # Additional utilities for Mac Mini (headless server)
    screen
    tmux
    htop
    nmap
    rsync
    ffmpeg
  ];
  
  # macOS-specific services
  services = {
    # Yabai window manager for macOS
    yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = true;
      config = {
        layout = "bsp";
        auto_balance = "on";
        window_placement = "second_child";
        window_gap = 10;
        top_padding = 10;
        bottom_padding = 10;
        left_padding = 10;
        right_padding = 10;
        mouse_follows_focus = "off";
        focus_follows_mouse = "off";
        mouse_modifier = "alt";
        mouse_action1 = "move";
        mouse_action2 = "resize";
      };
      extraConfig = ''
        # Rules for specific applications
        yabai -m rule --add app="^System Preferences$" manage=off
        yabai -m rule --add app="^Calculator$" manage=off
        yabai -m rule --add app="^Finder$" manage=off
      '';
    };
    
    # Keyboard shortcut daemon for macOS
    skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # Changing window focus
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east
        
        # Moving windows
        shift + alt - h : yabai -m window --warp west
        shift + alt - j : yabai -m window --warp south
        shift + alt - k : yabai -m window --warp north
        shift + alt - l : yabai -m window --warp east
        
        # Float / Unfloat window
        shift + alt - space : yabai -m window --toggle float; yabai -m window --grid 4:4:1:1:2:2
        
        # Make window native fullscreen
        alt - f : yabai -m window --toggle zoom-fullscreen
        
        # Toggle window split type
        alt - e : yabai -m window --toggle split
        
        # Balance size of windows
        shift + alt - 0 : yabai -m space --balance
      '';
    };
  };
  
  # Launchd services
  launchd.user.agents = {
    backup = {
      serviceConfig = {
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "${pkgs.rsync}/bin/rsync -a --delete ~/Documents ~/Pictures ~/Projects /Volumes/Backup"
        ];
        StartCalendarInterval = [
          { Hour = 2; Minute = 0; }
        ];
        StandardErrorPath = "/tmp/backup.err.log";
        StandardOutPath = "/tmp/backup.out.log";
      };
    };
  };
  
  # Homebrew apps (when Nix packages are not available)
  homebrew.casks = [
    "docker"
    "google-chrome"
    "zoom"
  ];
  
  # Mac App Store apps
  homebrew.masApps = {
    "Xcode" = 497799835;
    "Slack" = 803453959;
    "Keynote" = 409183694;
  };
}