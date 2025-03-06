{ pkgs, lib, config, ... }: {

  options = {
    homebrew-dev.enable =
      lib.mkEnableOption "enables homebrew-dev bundle";
  };

  config = lib.mkIf config.homebrew-dev.enable {

    homebrew = {
      casks = [
        # "zed"
      ];
    };

  };
}
