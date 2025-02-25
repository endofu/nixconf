{ pkgs, lib, config, ... }: {

  options = {
    devtools.enable =
      lib.mkEnableOption "enables devtools bundle";
  };

  config = lib.mkIf config.devtools.enable {
    environment.systemPackages = with pkgs; [
      lazygit
    ];

    
    # programs.starship = {
    #   enable = true;
    # };
  };
}
