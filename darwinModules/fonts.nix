{ pkgs, lib, config, ... }: {

  options = {
    fonts.enable =
      lib.mkEnableOption "enables fonts bundle";
  };

  config = lib.mkIf config.fonts.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.cousine
      nerd-fonts.inconsolata
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.jetbrains-mono
      nerd-fonts.victor-mono
      nerd-fonts.blex-mono
      nerd-fonts.im-writing
      nerd-fonts.mplus
      nerd-fonts.monaspace
    ];
  };
}
