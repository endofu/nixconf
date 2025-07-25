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
        enable = false;
      };

    };
    environment.systemPackages = with pkgs; [
      # postgresql
      librechat
    ];
  };
}
