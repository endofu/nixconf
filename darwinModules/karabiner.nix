{
  lib,
  config,
  pkgs,
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

    environment.systemPackages = with pkgs; [
      # karabiner-elements
    ];

    services.karabiner-elements.enable = true;

    # home-manager.users.arcadia = {
    #
    # };
  };
}
