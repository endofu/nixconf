{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../profiles/developer.nix
    ../../profiles/desktop.nix
    ../../profiles/darwin.nix
  ];

  # Common configuration for both NixOS and Darwin
  home.username = "arcadia";
  home.stateVersion = "24.11";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/arcadia" else "/home/arcadia";

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

    zed = {
      enable = true;
    };

    vscode = {
      enable = false;
    };
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
    #     slack
    discord

    # Development tools
    gnumake
    cmake
    gcc
  ];

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
