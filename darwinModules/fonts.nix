{ pkgs, lib, config, ... }: {

  options = {
    fonts.enable =
      lib.mkEnableOption "enables fonts bundle";
  };

  config = lib.mkIf config.fonts.enable {
    fonts.packages = [
      pkgs.nerd-fonts._0xproto
      pkgs.nerd-fonts.droid-sans-mono
    ];
  };
}
