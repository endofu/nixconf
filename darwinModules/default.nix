{...}: {

  imports = [
    ./basics.nix
    ./personal.nix
    ./fonts.nix
    ./terminal.nix
    ./devtools.nix
    ./zsh.nix
    ./homebrew-basic.nix
    ./homebrew-dev.nix

  ];

  basics.enable = true;
  personal.enable = true;
  fonts.enable = true;
  terminal.enable = true;
  devtools.enable = true;
  zsh.enable = false;
  homebrew-basic.enable = true;
  homebrew-dev.enable = true;
}
