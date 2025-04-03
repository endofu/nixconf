{ ... }:
{

  imports = [
    ./basics.nix
    ./macos.nix
    ./personal.nix
    ./fonts.nix
    ./terminal.nix
    ./devtools.nix
    ./homebrew-basic.nix
    ./homebrew-dev.nix
    ./aerospace.nix
  ];

  basics.enable = true;
  macos.enable = true;
  personal.enable = true;
  fonts.enable = true;
  terminal.enable = true;
  devtools.enable = true;
  homebrew-basic.enable = true;
  homebrew-dev.enable = true;
  aerospace.enable = true;
}
