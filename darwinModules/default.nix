{ pkgs, lib, ...}: {

  imports = [
    ./basics.nix
    ./fonts.nix
    ./terminal.nix
    ./devtools.nix
    ./zsh.nix
    ./homebrew-basic.nix
    ./homebrew-dev.nix

  ];

  basics.enable = true;
  fonts.enable = true;
  terminal.enable = true;
  devtools.enable = true;
  zsh.enable = true;
  homebrew-basic.enable = true;
  homebrew-dev.enable = true;
}
