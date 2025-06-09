{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./nix-settings.nix
    ./desktop.nix
    ./server.nix
    ./networking.nix
    ./llm.nix
    ./teamviewer.nix
  ];
}

