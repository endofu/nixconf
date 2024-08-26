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
      bat
      ripgrep
      fd
      lazygit
      lazydocker
      lazysql
      fzf
      tmux
      nerdfonts
      neovim
      vimPlugins.LazyVim
    ];
  };
}
