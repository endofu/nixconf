{ pkgs, lib, config, ... }: {

  options = {
    basics.enable =
      lib.mkEnableOption "enables basics bundle";
  };

  config = lib.mkIf config.basics.enable {
    environment.systemPackages = with pkgs; [
      nix-index
      nix-index-unwrapped
      zsh
      bat
      eza
      lsd
      fd
      ripgrep
    ];

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    programs.starship = {
      enable = true;
    };
  };
}
