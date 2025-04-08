{ config, lib, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./bash.nix
    ./utilities.nix
    ./git.nix
    ./tmux.nix
  ];
}