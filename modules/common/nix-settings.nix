{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  isNixOS = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # Common Nix settings for both NixOS and Darwin
  nix = {
    settings = {
      # auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      max-jobs = "auto";

      # Use binary cache
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E"
      ];
    };
    gc = {
      automatic = isNixOS;
      options = "--delete-older-than 30d";
      interval = {
        Day = 7;
      };
    };
  };

  system = mkMerge [
    (mkIf isNixOS {
      stateVersion = "24.11";
    })

    (mkIf isDarwin {
      activationScripts.postActivation.text = ''
        # Activate changes and rebuild
        /run/current-system/sw/bin/darwin-rebuild build
      '';
    })
  ];
}
