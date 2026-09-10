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
    {
      services.netbird = {
        enable = true;
        package = cfg.package;
      };
    }
    (optionalAttrs (options ? homebrew) (mkIf cfg.ui.enable {
      homebrew = {
        taps = [
          {
            name = "netbirdio/tap";
            trusted = true;
          }
        ];
        casks = [
          "netbird-ui"
        ];
      };
    }))
    (optionalAttrs (options ? launchd) {
      launchd.daemons.netbird.script = mkForce ''
        mkdir -p /var/run/netbird /var/lib/netbird
        ln -sf /var/run/netbird/sock /var/run/netbird.sock
        exec ${cfg.package}/bin/netbird service run
      '';
    })
    (optionalAttrs (options.services.netbird ? ui) (mkIf cfg.ui.enable {
      services.netbird.ui.enable = true;
    }))
  ]);
}
