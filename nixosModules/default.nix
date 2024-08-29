{ pkgs, lib, ...}: {

  imports = [
    ./devtools.nix
    # ./nodejs.nix
    # ./python.nix
    ./basics.nix
  ];

  devtools.enable = true;
  # nodejs.enable = false;
  # python.enable = false;
  basics.enable = true;
}
