{ pkgs, lib, ...}: {

  imports = [
    ./devtools.nix
    ./nodejs.nix
    ./python.nix
    ./basics.nix
  ];

  devtools.enable = true;
  nodejs.enable = true;
  python.enable = true;
  basics.enable = true;
}
