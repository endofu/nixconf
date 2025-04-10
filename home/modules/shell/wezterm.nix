{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.shell.wezterm;
in
{
  options.modules.shell.wezterm = {
    enable = mkEnableOption "wezterm configuration";

  };

  config = mkIf cfg.enable {

    programs = {
      wezterm = {
        enable = true;
        extraConfig = ''
          return {
            window_background_opacity = 0.9,
            macos_window_background_blur = 20,
            font = wezterm.font("BlexMono Nerd Font Mono"),
            font_size = 14.0,
            cell_width = 0.9,
            color_scheme = "Tokyo Night Storm",
            hide_tab_bar_if_only_one_tab = true,
            window_decorations = "RESIZE",

            enable_wayland = true, 
            native_macos_fullscreen_mode = true,
          }
        '';
      };
    };
  };
}
