{
  lib,
  config,
  ...
}:
{

  options = {
    aerospace.enable = lib.mkEnableOption "enables aerospace bundle";
  };

  config = lib.mkIf config.aerospace.enable {
    # environment.systemPackages = with pkgs; [
    #
    # ];

    home-manager.users.arcadia = {
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
  };
}
