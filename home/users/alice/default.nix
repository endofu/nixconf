{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/developer.nix
  ];

  # Common configuration for both NixOS and Darwin
  home.username = "alice";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/alice" else "/home/alice";
  
  # Enable specific shell modules
  modules.shell = {
    git = {
      enable = true;
      userName = "Alice Smith";
      userEmail = "alice@example.com";
      signing = {
        enable = true;
        key = "XXXXXXXXXXXXXXXX";
      };
    };
    
    zsh = {
      enable = true;
      defaultShell = true;
    };
    
    tmux.enable = true;
  };
  
  # Configure editors
  modules.editors = {
    neovim = {
      enable = true;
      defaultEditor = true;
      lsp = {
        enable = true;
        servers = [ "rust_analyzer" "pyright" "tsserver" "nil" ];
      };
    };
    
    vscode = {
      enable = true;
      userSettings = {
        "workbench.colorTheme" = "Dracula";
        "editor.fontSize" = 15;
      };
    };
  };
  
  # Common packages for all platforms
  home.packages = with pkgs; [
    # Communication tools
    slack
    discord
    
    # Utilities
    keepassxc
    zoxide
    
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
          "browser.startup.homepage" = "https://nixos.org";
          "browser.search.region" = "US";
          "browser.search.isUS" = true;
          "browser.useragent.locale" = "en-US";
        };
      };
    };
  };
  
  # SSH configuration
#   programs.ssh = {
#     enable = true;
#     matchBlocks = {
#       "github.com" = {
#         identityFile = "${config.home.homeDirectory}/.ssh/github";
#         extraOptions = {
#           AddKeysToAgent = "yes";
#         };
#       };
#
#       "server" = {
#         hostname = "server.example.com";
#         user = "alice";
#         port = 22;
#         identityFile = "${config.home.homeDirectory}/.ssh/server";
#       };
#     };
#   };
}
