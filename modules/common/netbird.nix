{
  config,
  lib,
  pkgs,
  options,
  ...
}:

with lib;

let
  cfg = config.modules.netbird;
in
{
  options.modules.netbird = {
    enable = mkEnableOption "netbird configuration";
    package = mkOption {
      type = types.package;
      default = pkgs.netbird;
      description = "The netbird package to use";
    };
    ui = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable the NetBird desktop UI client";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Linux (NixOS): Native systemd service and packages
    (mkIf (!pkgs.stdenv.hostPlatform.isDarwin) (mkMerge [
      {
        services.netbird = {
          enable = true;
          package = cfg.package;
        };
      }
      (optionalAttrs (options.services.netbird ? ui) (mkIf cfg.ui.enable {
        services.netbird.ui.enable = true;
      }))
    ]))

    # Darwin (macOS): NetBird daemon and UI are managed via Homebrew.
    # Nix's launchd daemon (org.nixos.netbird) conflicts with Homebrew's daemon (netbird),
    # so we explicitly disable nix-darwin's services.netbird and rely on Homebrew.
    (optionalAttrs (options ? homebrew) {
      services.netbird.enable = mkForce false;
      homebrew = {
        taps = [
          {
            name = "netbirdio/tap";
            trusted = true;
          }
        ];
        brews = [
          "netbirdio/tap/netbird"
        ];
        casks = mkIf cfg.ui.enable [
          "netbird-ui"
        ];
      };
    })
  ]);
}
