{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.perforce;

  p4d-fhs = pkgs.buildFHSEnv {
    name = "p4d-fhs";
    targetPkgs = pkgs: (with pkgs; [
      glibc
      zlib
    ]);
    runScript = "/opt/perforce/bin/p4d";
  };

  p4-fhs = pkgs.buildFHSEnv {
    name = "p4";
    targetPkgs = pkgs: (with pkgs; [
      glibc
      zlib
    ]);
    runScript = "/opt/perforce/bin/p4";
  };
in
{
  options.modules.perforce = {
    enable = mkEnableOption "Perforce Helix Core Server";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      p4-fhs
      p4d-fhs
    ];

    users.groups.perforce = { };
    users.users.perforce = {
      isSystemUser = true;
      group = "perforce";
      home = "/var/lib/perforce";
      createHome = true;
    };

    systemd.services.p4d = {
      description = "Perforce Helix Core Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "perforce";
        Group = "perforce";
        # IMPORTANT: Append -C1 here if AWS was case-insensitive, or -xi if Unicode was enabled
        ExecStart = "${p4d-fhs}/bin/p4d-fhs -r /var/lib/perforce/root -p 1666 -L /var/lib/perforce/p4d.log -v server=1";
        LimitNOFILE = 1048576;
        Restart = "on-failure";
      };
    };
  };
}
