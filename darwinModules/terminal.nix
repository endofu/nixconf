{ pkgs, lib, config, ... }: {

  options = {
    terminal.enable =
      lib.mkEnableOption "enables terminal bundle";
  };

  config = lib.mkIf config.terminal.enable {
    environment.systemPackages = with pkgs; [
       tmux
       mc
       bat
       eza
       lsd
       fd
       fzf
       ripgrep
       nushell
       zoxide
    ];
  };
}
