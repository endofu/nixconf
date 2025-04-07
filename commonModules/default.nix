{ ... }:
{

  imports = [
    ./basics.nix
    ./personal.nix
    ./fonts.nix
    ./terminal.nix
    ./devtools.nix
  ];

  basics.enable = true;
  personal.enable = true;
  fonts.enable = true;
  terminal.enable = true;
  devtools.enable = true;
}
