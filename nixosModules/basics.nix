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

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$line_break"
          "$package"
          "$line_break"
          "$character"
        ];
        scan_timeout = 10;
        character = {
          success_symbol = "➜";
          error_symbol = "➜";
        };
      };
    };
  };
}
