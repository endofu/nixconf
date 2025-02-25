{ pkgs, lib, config, ... }: {

  options = {
    zsh.enable =
      lib.mkEnableOption "enables zsh bundle";
  };

  config = lib.mkIf config.zsh.enable {
    environment.systemPackages = with pkgs; [
      zsh
      zsh-autosuggestions
      zsh-nix-shell
      zsh-syntax-highlighting
    ];
  };
}
