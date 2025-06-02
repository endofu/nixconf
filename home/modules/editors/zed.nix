{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.editors.zed;
in
{
  options.modules.editors.zed = {
    enable = mkEnableOption "zed configuration";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "lua"
        "toml"
        "oxocarbon"
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
        buffer_font_family = "BlexMono Nerd Font Mono";
        # ui_font_family = "MonaspiceXE Nerd Font";
        relative_line_numbers = true;
        theme = {
          mode = "system";
          light = "Oxocarbon Light (Variation I)";
          dark = "Oxocarbon Dark (IBM Carbon)";
        };

      };
    };
  };
}
