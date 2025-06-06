{
  inputs,
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.karabiner;
in
{
  options.modules.karabiner = {
    enable = mkEnableOption "Karabiner Elements keyboard customization";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        inherit (inputs.nixpkgs-stable.legacyPackages.${prev.system}) karabiner-elements;
      })
    ];

    services.karabiner-elements.enable = true;
  };
}
