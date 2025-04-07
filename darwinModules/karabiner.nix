{
  lib,
  config,
  inputs,
  ...
}:
{

  options = {
    karabiner.enable = lib.mkEnableOption "enables karabiner bundle";
  };

  config = lib.mkIf config.karabiner.enable {

    nixpkgs.overlays = [
      (final: prev: {
        inherit (inputs.nixpkgs-stable.legacyPackages.${prev.system}) karabiner-elements;
      })
    ];

    services.karabiner-elements.enable = true;

    # home-manager.users.arcadia = {
    # TODO: add json to home folder
    # };
  };
}
