{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.shell.kitty;
in
{
  options.modules.shell.kitty = {
    enable = mkEnableOption "kitty configuration";

  };

  config = mkIf cfg.enable {

    programs = {
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        font = {
          name = "VictorMono Nerd Font Mono";
          size = 13;
        };
        themeFile = "Spacedust";
        settings = {
          enable_audio_bell = false;
          update_check_interval = 0;
        };
      };
    };
  };
}
