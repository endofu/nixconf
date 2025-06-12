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
      userKeymaps = [ ];

      userSettings = {
        hour_format = "hour24";
        auto_update = false;
        telemetry = {
          metrics = false;
        };
        vim_mode = true;
        soft_wrap = "editor_width";
        autosave = {
          after_delay = {
            milliseconds = 1000;
          };
        };
        formatter = "language_server";
        format_on_save = "on";
        lsp = {
          vtsls = {
            settings = {
              typescript = {
                preferences = {
                  preferTypeOnlyAutoImports = true;
                };
              };
            };
          };
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

        context_servers = {
          "Context7" = {
            command = {
              path = "pnpx";
              args = [
                "@upstash/context7-mcp"
              ];
            };
            settings = { };
          };
        };
      };
    };
  };
}
