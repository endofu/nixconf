{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.gemini;
in
{
  options.modules.gemini = {
    enable = mkEnableOption "gemini configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      gemini-cli-bin
      google-chrome
    ];
  };
}
