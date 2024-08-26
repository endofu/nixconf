{ pkgs, lib, config, ... }: {

  options = {
    nodejs.enable =
      lib.mkEnableOption "enables nodejs bundle";
  };

  config = lib.mkIf config.nodejs.enable {
    environment.systemPackages = with pkgs; [
      nodejs_20
      corepack_20
      nodenv
    ];
  };
}
