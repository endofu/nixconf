{
  config,
  ...
}:

{
  imports = [
    ../modules/desktop
  ];

  modules.desktop = {
    obsidian.enable = true;
  };

  # XDG directories
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    cacheHome = "${config.home.homeDirectory}/.cache";
  };
}
