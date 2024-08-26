{ pkgs, lib, config, ... }: {

  options = {
    basics.enable =
      lib.mkEnableOption "enables basics bundle";
  };

  config = lib.mkIf config.basics.enable {
    environment.systemPackages = with pkgs; [
      zsh
    ];

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

  };
}
