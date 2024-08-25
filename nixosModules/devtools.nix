{ pkgs, lib, config, ... }: {

  options = {
    devtools.enable =
      lib.mkEnableOption "enables devtools bundle";
  };

  config = lib.mkIf config.devtools.enable {
    environment.systemPackages = with pkgs; [
      git
      alacritty
      tmux
      bat
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
