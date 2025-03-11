{ lib, config, ... }: {

  options = { devtools.enable = lib.mkEnableOption "enables devtools bundle"; };

  config = lib.mkIf config.devtools.enable {

    home-manager.users.arcadia = {
      programs = {
        zed-editor = {
          enable = true;
          extensions = [ "nix" "toml" ];
          userSettings = {
            hour_format = "hour24";
            auto_update = false;
            telemetry = { metrics = false; };
            vim_mode = true;
            autosave = { after_delay = { milliseconds = 1000; }; };
            formatter = "language_server";
            format_on_save = true;
            lsp = {
              rust-analyzer = {

                binary = {
                  #                        path = lib.getExe pkgs.rust-analyzer;
                  path_lookup = true;
                };
              };
              nix = { binary = { path_lookup = true; }; };
              nil = {
                initialization_options = {
                  formatting = { command = [ "nixfmt" ]; };
                  nix = { flake = { autoArchive = true; }; };
                };
              };
            };
            theme = {
              mode = "system";
              light = "One Light";
              dark = "One Dark";
            };

          };
        };

        lazygit = { enable = true; };
      };
    };
  };
}
