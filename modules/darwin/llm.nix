{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.llm;
in
{
  options.modules.llm = {
    enable = mkEnableOption "LLM tools (ollama via Homebrew)";

    ollama = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install ollama for local LLM inference";
      };
    };
  };

  config = mkIf cfg.enable {
    # Ollama on macOS is installed via Homebrew cask
    homebrew.casks = optionals cfg.ollama.enable [
      "ollama"
    ];
  };
}
