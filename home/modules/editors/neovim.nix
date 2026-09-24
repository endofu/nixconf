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

      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
    };

    # Prevent home-manager from generating init.lua which overwrites LazyVim's entrypoint
    xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

    # Extra packages for neovim
    home.packages = with pkgs; [
      # Core dependencies
      python314
      rustc
      cargo
      go
      ripgrep
      fd

      # LSPs and linters configured in LazyVim
      typos-lsp
      statix
      nixd
      nixpkgs-fmt

      # For telescope (use default stdenv compiler which is clang on mac, gcc on linux)
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      gcc
    ] ++ [
      gnumake
    ];

    # Link LazyVim out-of-store so Lazy can write to lazy-lock.json
    home.activation.linkLazyVim = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -L ${config.home.homeDirectory}/.config/nvim ] && [ -d ${config.home.homeDirectory}/.config/nvim ]; then
        if [ -f ${config.home.homeDirectory}/.config/nvim/lazy-lock.json ]; then
          $DRY_RUN_CMD cp -f ${config.home.homeDirectory}/.config/nvim/lazy-lock.json ${config.home.homeDirectory}/Code/nixconf/home/dotfiles/LazyVim/lazy-lock.json
        fi
        $DRY_RUN_CMD rm -rf ${config.home.homeDirectory}/.config/nvim
      fi
      $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/Code/nixconf/home/dotfiles/LazyVim ${config.home.homeDirectory}/.config/nvim
    '';
  };
}
