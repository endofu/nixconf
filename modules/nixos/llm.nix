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
        package = pkgs.ollama-cuda;
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
