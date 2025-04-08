# Custom packages, that can be defined similarly to ones from nixpkgs
# You can use 'nix-shell -p nix-info --run "nix-info -m"' to check if
# a package is available on your system.
{ pkgs ? import <nixpkgs> {} }:

{
  # Custom packages
  custom-neofetch = pkgs.callPackage ./custom-neofetch {};
  
  # Example: A custom template generator
  project-template = pkgs.callPackage ./project-template {};
}