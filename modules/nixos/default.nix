{ config, lib, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./server.nix
  ];
}