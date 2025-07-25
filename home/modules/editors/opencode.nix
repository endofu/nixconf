{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.editors.opencode;
in
{
  options.modules.editors.opencode = {
    enable = mkEnableOption "opencode configuration";
  };

  config = mkIf cfg.enable {
    # Install neovim and set as default editor if requested
    # programs.bun = {
    #   enable = true;
    #   settings = {
    #     smol = true;
    #     telemetry = false;
    #     test = {
    #       coverage = true;
    #     };
    #   };
    # };

    # Extra packages for neovim
    # home.packages = with pkgs; [
    #   # Core dependencies
    # ];

    home.file.".config/opencode/opencode.json".source = ../../dotfiles/opencode.json;
  };
}
