{ pkgs, lib, config, ... }: {

  options = {
    python.enable =
      lib.mkEnableOption "enables python bundle";
  };

  config = lib.mkIf config.python.enable {
    environment.systemPackages = with pkgs; [
      python3
    ];
  };
}
