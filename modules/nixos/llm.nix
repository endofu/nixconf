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
    enable = mkEnableOption "LLM tools (ollama service)";

    ollama = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable ollama service for local LLM inference";
      };

      cuda = mkOption {
        type = types.bool;
        default = true;
        description = "Use CUDA-enabled ollama package for GPU acceleration";
      };
    };

    open-webui = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Open WebUI for ollama";
      };
    };
  };

  config = mkIf cfg.enable {
    services.ollama = mkIf cfg.ollama.enable {
      enable = true;
      package = if cfg.ollama.cuda then pkgs.ollama-cuda else pkgs.ollama;
    };

    services.open-webui = mkIf cfg.open-webui.enable {
      enable = true;
    };
  };
}
