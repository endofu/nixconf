{ config, lib, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./networking.nix
    ./nix-settings.nix
  ];
}
