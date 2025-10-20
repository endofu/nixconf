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
        "astro"
        "oxocarbon"
        "prisma"
        "env"
        "log"
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
            source = "custom";
            command = "pnpx";
            args = [
              "@upstash/context7-mcp"
            ];
            env = { };
          };
          "Playwright" = {
            source = "custom";
            command = "pnpx";
            args = [
              "@playwright/mcp@latest"
            ];
            env = { };
          };
          "Chrome-Devtools" = {
            source = "custom";
            command = "pnpx";
            args = [
              "chrome-devtools-mcp@latest"
            ];
            env = { };
          };
          "Linear" = {
            source = "custom";
            command = "pnpx";
            args = [
              "mcp-remote"
              "https://mcp.linear.app/sse"
            ];
            env = { };
          };
          "Effect" = {
            source = "custom";
            command = "pnpx";
            args = [
              "effect-mcp@latest"
            ];
            env = { };
          };
          "Sequential" = {
            source = "custom";
            command = "pnpx";
            args = [
              "@modelcontextprotocol/server-sequential-thinking"
            ];
            env = { };
          };
        };
      };
    };
  };
}
