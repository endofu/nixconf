{ config, lib, pkgs, ... }:

{
  imports = [
    ./developer.nix
    ./minimal.nix
  ];
}