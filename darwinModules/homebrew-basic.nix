{ pkgs, lib, config, ... }: {

  options = {
    homebrew-basic.enable =
      lib.mkEnableOption "enables homebrew-basic bundle";
  };

  config = lib.mkIf config.homebrew-basic.enable {

    homebrew = {
      casks = [
        "wezterm"
        "sublime-text"
      ];
    };

  };
}
