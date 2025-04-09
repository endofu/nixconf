{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.editors.neovim;
in
{
  options.modules.editors.neovim = {
    enable = mkEnableOption "neovim configuration";

    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to set neovim as the default editor";
    };
  };

  config = mkIf cfg.enable {
    # Install neovim and set as default editor if requested
    programs.neovim = {
      enable = true;
      defaultEditor = cfg.defaultEditor;

      withNodeJs = true;
      withPython3 = true;
    };

    # Extra packages for neovim
    home.packages = with pkgs; [
      # Core dependencies
      python314
      rustc
      cargo
      go
      ripgrep
      fd

      # For telescope
      gcc
      gnumake
    ];

    home.file.".config/nvim" = {
      source = ../../dotfiles/LazyVim;
      recursive = true;
    };
  };
}
