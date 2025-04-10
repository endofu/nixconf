{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../profiles/developer.nix
  ];

  # Common configuration for both NixOS and Darwin
  home.username = "elaine";
  home.stateVersion = "24.11";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/elaine" else "/home/elaine";

  # Enable specific shell modules
  modules.shell = {
    git = {
      enable = true;
      userName = "endofu";
      userEmail = "endofu@gmail.com";
      /*
        signing = {
          enable = true;
          key = "XXXXXXXXXXXXXXXX";
        };
      */
    };

    #     zsh = {
    #       enable = true;
    #       defaultShell = true;
    #     };

    tmux.enable = true;
  };

  # Configure editors
  modules.editors = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    vscode = {
      enable = false;
      userSettings = {
        "workbench.colorTheme" = "Dracula";
        "editor.fontSize" = 15;
      };
    };
  };

  # Configure desktop
  modules.desktop = {
    copyq = {
      enable = true;
    };
  };

  # Common packages for all platforms
  home.packages = with pkgs; [
    # Communication tools
    #     slack
    discord

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
          #           "browser.search.region" = "US";
          #           "browser.search.isUS" = true;
          #           "browser.useragent.locale" = "en-US";
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
      /*
        "server" = {
          hostname = "server.example.com";
          user = "alice";
          port = 22;
          identityFile = "${config.home.homeDirectory}/.ssh/server";
        };
      */
    };
  };
}
