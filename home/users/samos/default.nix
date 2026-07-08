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
      enable = false;
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
    # discord

    # Development tools
    gnumake
    cmake
    gcc
  ];

  # SSH configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        IdentityFile = "${config.home.homeDirectory}/.ssh/github";
        AddKeysToAgent = "yes";
      };
      "codeberg.org" = {
        IdentityFile = "${config.home.homeDirectory}/.ssh/github";
        AddKeysToAgent = "yes";
      };

      "*" = {
        ForwardAgent = "no";
        AddKeysToAgent = "no";
        Compression = "no";
        ServerAliveInterval = "0";
        ServerAliveCountMax = "3";
        HashKnownHosts = "no";
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
