{ lib, config, ... }:
{

  options = {
    devtools.enable = lib.mkEnableOption "enables devtools bundle";
  };

  config = lib.mkIf config.devtools.enable {

    home-manager.users.arcadia = {
      programs = {
        zed-editor = {
          enable = true;
          extensions = [
            "nix"
            "toml"
            "kanagawa-themes"
            "not-material-theme"
          ];
          userSettings = {
            hour_format = "hour24";
            auto_update = false;
            telemetry = {
              metrics = false;
            };
            vim_mode = true;
            autosave = {
              after_delay = {
                milliseconds = 1000;
              };
            };
            formatter = "language_server";
            format_on_save = true;
            lsp = {
              rust-analyzer = {

                binary = {
                  #                        path = lib.getExe pkgs.rust-analyzer;
                  path_lookup = true;
                };
              };
              nix = {
                binary = {
                  path_lookup = true;
                };
              };
              nil = {
                initialization_options = {
                  formatting = {
                    command = [ "nixfmt" ];
                  };
                  nix = {
                    flake = {
                      autoArchive = true;
                    };
                  };
                };
              };
            };
            buffer_font_family = "MonaspiceNe Nerd Font";
            ui_font_family = "MonaspiceXE Nerd Font";
            theme = {
              mode = "system";
              light = "Not Material Light Cyan";
              dark = "Kanagawa Wave";
            };

          };
        };

        lazygit = {
          enable = true;
        };
      };
    };
  };
}
