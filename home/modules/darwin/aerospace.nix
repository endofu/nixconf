{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.darwin.aerospace;
in
{
  options.modules.darwin.aerospace = {
    enable = mkEnableOption "aerospace configuration";

  };

  config = mkIf cfg.enable {

    programs = {
      aerospace = {
        enable = true;
        userSettings = {
          start-at-login = true;
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;
          mode.main.binding = {
            ctrl-alt-r = "reload-config";

            ctrl-alt-w = "move-workspace-to-monitor next --wrap-around";

            ctrl-alt-h = "focus left --boundaries all-monitors-outer-frame";
            ctrl-alt-j = "focus down --boundaries all-monitors-outer-frame";
            ctrl-alt-k = "focus up --boundaries all-monitors-outer-frame";
            ctrl-alt-l = "focus right --boundaries all-monitors-outer-frame";

            ctrl-alt-b = "workspace Browser";
            ctrl-alt-c = "workspace Console";
            ctrl-alt-f = "workspace Finder";
            ctrl-alt-n = "workspace Notes";
            ctrl-alt-t = "workspace Tasks";

            ctrl-alt-1 = "workspace 1";
            ctrl-alt-2 = "workspace 2";
            ctrl-alt-3 = "workspace 3";
            ctrl-alt-4 = "workspace 4";
            ctrl-alt-5 = "workspace 5";
            ctrl-alt-6 = "workspace 6";
            ctrl-alt-7 = "workspace 7";
            ctrl-alt-8 = "workspace 8";
            ctrl-alt-9 = "workspace 9";

            ctrl-shift-alt-1 = "move-node-to-workspace 1";
            ctrl-shift-alt-2 = "move-node-to-workspace 2";
            ctrl-shift-alt-3 = "move-node-to-workspace 3";
            ctrl-shift-alt-4 = "move-node-to-workspace 4";
            ctrl-shift-alt-5 = "move-node-to-workspace 5";
            ctrl-shift-alt-6 = "move-node-to-workspace 6";
            ctrl-shift-alt-7 = "move-node-to-workspace 7";
            ctrl-shift-alt-8 = "move-node-to-workspace 8";
            ctrl-shift-alt-9 = "move-node-to-workspace 9";
          };
          on-window-detected = [
            {
              "if" = {
                app-id = "com.apple.finder";
                # during-aerospace-startup = true;
              };
              run = [
                "move-node-to-workspace Finder"
              ];
            }
            {
              "if" = {
                app-id = "com.github.wez.wezterm";
                # during-aerospace-startup = true;
              };
              run = [
                "move-node-to-workspace Console"
              ];
            }
            {
              "if" = {
                app-id = "md.obsidian";
                # during-aerospace-startup = true;
              };
              run = [
                "move-node-to-workspace Notes"
              ];
            }
            {
              "if" = {
                app-id = "app.zen-browser.zen";
                # during-aerospace-startup = true;
              };
              run = [
                "move-node-to-workspace Browser"
              ];
            }
            {
              "if" = {
                app-id = "com.TickTick.task.mac";
                # during-aerospace-startup = true;
              };
              run = [
                "move-node-to-workspace Tasks"
              ];
            }
          ];
        };
      };
    };
  };
}
