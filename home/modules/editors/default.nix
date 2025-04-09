{ config, lib, pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./vscode.nix
  ];
}