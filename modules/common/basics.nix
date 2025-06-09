{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.basics;
in
{
  options.modules.basics = {
    enable = mkEnableOption "basics configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      openssl
      nix-index
      nix-index-unwrapped
      nh
      coreutils
      curl
      wget
      gnupg
      #      gnumake
      #      gcc
      #      libgcc
    ];
  };
}
