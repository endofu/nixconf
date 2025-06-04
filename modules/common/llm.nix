{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.llm;
in
{
  options.modules.llm = {
    enable = mkEnableOption "llm configuration";
  };

  config = mkIf cfg.enable {
    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";

      };
      open-webui = {
        enable = true;
      };

    };
    environment.systemPackages = with pkgs; [
      librechat
      claude-code
      codex
    ];
  };
}
