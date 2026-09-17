{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.shell.direnv;
in
{
  options.modules.shell.direnv = {
    enable = mkEnableOption "direnv configuration";

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable bash integration for direnv";
    };

    enableZshIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable zsh integration for direnv";
    };

    nix-direnv = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable nix-direnv integration";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = cfg.enableBashIntegration;
      enableZshIntegration = cfg.enableZshIntegration;
      nix-direnv.enable = cfg.nix-direnv.enable;
    };
  };
}
