{ pkgs, lib, config, ... }: {

  options = {
    devtools.enable =
      lib.mkEnableOption "enables devtools bundle";
  };

  config = lib.mkIf config.devtools.enable {

    home-manager.users.arcadia = {
      programs = {
        zed-editor = {
          enable = true;
          extensions = ["nix"];
        };

        lazygit = {
          enable = true;
        };
      };
    };
  };
}
