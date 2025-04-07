{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {
    devtools.enable = lib.mkEnableOption "enables devtools bundle";
  };

  config = lib.mkIf config.devtools.enable {

    environment.systemPackages = with pkgs; [
      rustc
      cargo
      go
    ];

    home-manager.users.arcadia = {
      programs = {
        zed-editor = {
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

        lazygit = {
          enable = true;
          settings = {
            gui = {
              showRandomTip = false;
              showNumstatInFilesView = true;
              showBottomLine = true;
              showPanelJumps = false;
              nerdFontsVersion = "3";
              showDivergenceFromBaseBranch = "arrowAndNumber";
              filterMode = "fuzzy";
            };
            git = {
              paging = {
                externalDiffCommand = "difft --color=always";
              };
              parseEmoji = true;

            };
          };
        };

        neovim = {
          enable = true;
          withNodeJs = true;
          withPython3 = true;
        };
      };
      home.file.".config/nvim" = {
        source = ../dotfiles/LazyVim;
        recursive = true;
      };

    };
  };
}
