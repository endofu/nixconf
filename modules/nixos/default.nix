{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./desktop.nix
    ./server.nix
    ./networking.nix
    ./llm.nix
    ./teamviewer.nix
  ];
}

