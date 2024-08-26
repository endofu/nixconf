{ pkgs, lib, ...}: {

  imports = [
    ./devtools.nix
    ./nodejs.nix
    ./python.nix
  ];

  devtools.enable = true;
  nodejs.enable = true;
  python.enable = true;

}
