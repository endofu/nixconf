{ pkgs, lib, config, ... }: {

  options = {
    basics.enable =
      lib.mkEnableOption "enables basics bundle";
  };

  config = lib.mkIf config.basics.enable {
    environment.systemPackages = with pkgs; [
      git
      nix-index
      nix-index-unwrapped
      gnumake
      gcc	
      libgcc
      zsh
      bat
      eza
      lsd
      fd
      ripgrep
    ];

    # programs.zsh.enable = true;
    # users.defaultUserShell = pkgs.zsh;
  };
}
