{ pkgs, lib, ...}: {

  imports = [
    ./devtools.nix
    # ./nodejs.nix
    # ./python.nix
    ./basics.nix
    ./podman.nix
    ./media.nix
  ];

  devtools.enable = false;
  # nodejs.enable = false;
  # python.enable = false;
  basics.enable = true;
  podman.enable = false;
  media.enable = true;
}
