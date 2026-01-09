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

  programs.home-manager.enable = true;

  # Allow broken packages for Darwin
  nixpkgs.config.allowBroken = true;

  # Common configuration for both NixOS and Darwin
  home.username = "samos";
  home.stateVersion = "25.11";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/samos" else "/home/samos";

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

    zsh = {
      enable = true;
      defaultShell = true;
    };

    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
    };
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
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com" = {
        identityFile = "${config.home.homeDirectory}/.ssh/github";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };

      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
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
