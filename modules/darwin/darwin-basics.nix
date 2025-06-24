{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.modules.darwin-basics;
in
{

  options.modules.darwin-basics = {
    enable = mkEnableOption "enables darwin-basics bundle";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.reattach-to-user-namespace
    ];

    nix = {
      settings = {
        # auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
        max-jobs = "auto";
      };
    };
  };
}
