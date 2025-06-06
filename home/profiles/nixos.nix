{
  ...
}:

{
  imports = [
    ../modules/nixos
  ];

  modules.nixos = {
    copyq.enable = true;
  };
}
