{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    enable = mkEnableOption "fonts configuration";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.cousine
      nerd-fonts.inconsolata
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.jetbrains-mono
      nerd-fonts.victor-mono
      nerd-fonts.blex-mono
      nerd-fonts.im-writing
      nerd-fonts.monaspace
    ];
  };
}
