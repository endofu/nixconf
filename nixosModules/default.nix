{ pkgs, lib, ...}: {

  imports = [
    ./devtools.nix
    # ./nodejs.nix
    # ./python.nix
    ./basics.nix
    ./podman.nix
  ];

  devtools.enable = true;
  # nodejs.enable = false;
  # python.enable = false;
  basics.enable = true;
  podman.enable = true;
}
