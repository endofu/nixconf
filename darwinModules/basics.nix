{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    basics.enable = lib.mkEnableOption "enables basics bundle";
  };

  config = lib.mkIf config.basics.enable {
    environment.systemPackages = with pkgs; [
      git
      openssl
      nix-index
      nix-index-unwrapped
      nh
      #      gnumake
      #      gcc
      #      libgcc
    ];

    security.pam.enableSudoTouchIdAuth = true;

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
          pull.rebase = true;
          column.ui = "auto";
          branch.sort = "committerdate";
          tag.sort = "version:refname";
          # init.defaultBranch = "main";
          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            renames = true;
          };
          push = {
            default = "simple";
            autoSetupRemote = true;
            followTags = true;
          };
          fetch = {
            prune = true;
            pruneTags = true;
            all = true;
          };
        };
      };
    };
  };
}
