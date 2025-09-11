{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../profiles/developer.nix
    ../../profiles/desktop.nix
    ../../profiles/nixos.nix
  ];

  # Common configuration for both NixOS and Darwin
  home.username = "sparta";
  home.stateVersion = "24.11";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/sparta" else "/home/sparta";

  # Enable specific shell modules
  modules.shell = {
    git = {
      enable = true;
      userName = "endofu";
      userEmail = "endofu@gmail.com";
    };
    tmux.enable = true;
  };

  # Configure editors
  modules.editors = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    zed.enable = false;

    vscode.enable = false;
  };

  # Configure desktop
  modules.desktop = {
    obsidian = {
      enable = true;
    };
  };

  # Common packages for all platforms
  home.packages = with pkgs; [
    # Communication tools
    # slack
    # discord

    # Development tools
    gnumake
    cmake
    gcc
  ];

  # Program-specific configurations
  programs = {
    # Browser
    firefox = {
      enable = pkgs.stdenv.isLinux;
      profiles.default = {
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "https://google.com";
        };
      };
    };
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "${config.home.homeDirectory}/.ssh/github";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
