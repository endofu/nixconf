{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.lazygit;
in {
  options.modules.shell.lazygit = {
    enable = mkEnableOption "lazygit configuration";

  };

  config = mkIf cfg.enable {

    programs = {
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
    };
  };
}
