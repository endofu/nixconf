{ pkgs, lib, config, ... }: {

  options = {
    devtools.enable =
      lib.mkEnableOption "enables devtools bundle";
  };

  config = lib.mkIf config.devtools.enable {
    environment.systemPackages = with pkgs; [
      git
      alacritty
      mc
      tmux
      lazygit
      lazydocker
      lazysql
      fzf
      nerdfonts
      neovim
      vimPlugins.LazyVim
    ];
  };
}
