{ config, lib, pkgs, ... }:

{
  imports = [
    ./networking.nix
    ./nix-settings.nix
  ];
}