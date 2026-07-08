{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.herdr;
  herdrPkg = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.modules.herdr = {
    enable = mkEnableOption "herdr application";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      herdrPkg
    ];
  };
}
