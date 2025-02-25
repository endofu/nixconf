{ pkgs, lib, config, ... }: {

  options = {
    devtools.enable =
      lib.mkEnableOption "enables devtools bundle";
  };

  config = lib.mkIf config.devtools.enable {
    environment.systemPackages = with pkgs; [
      lazygit
    ];


    home-manager.users.arcadia = {
      programs = {
        zed-editor = {
          enable = true;
          extensions = ["nix"];
        };
      };
    };
  };
}
