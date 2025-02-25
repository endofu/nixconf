{ pkgs, lib, config, ... }: {

  options = {
    basics.enable =
      lib.mkEnableOption "enables basics bundle";
  };

  config = lib.mkIf config.basics.enable {
    environment.systemPackages = with pkgs; [
       git
       openssl
#      nix-index
#      nix-index-unwrapped
#      gnumake
#      gcc	
#      libgcc
    ];

    homebrew = {
      enable = true;

      onActivation = {
        cleanup = "uninstall";
      };
    };

    home-manager.users.arcadia = {
      programs.git = {
          enable = true;
          userName = "endofu";
          userEmail = "endofu@gmail.com";
          ignores = [ ".DS_Store" ];
          extraConfig = {
              init.defaultBranch = "main";
              push.autoSetupRemote = true;
          };
      };
  };

    security.pam.enableSudoTouchIdAuth = true;
  };
}
