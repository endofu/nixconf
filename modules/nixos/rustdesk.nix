{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.rustdesk;

  rustdeskPatched = pkgs.runCommand "rustdesk-patched" {
    nativeBuildInputs = [ pkgs.patchelf ];
  } ''
    mkdir -p $out
    cp -r ${pkgs.rustdesk-flutter}/* $out/
    chmod -R u+w $out
    substituteInPlace $out/bin/rustdesk \
      --replace-warn "${pkgs.rustdesk-flutter}" "$out"
    sed -i '2i export LD_LIBRARY_PATH="${pkgs.xdotool}/lib:$LD_LIBRARY_PATH"' $out/bin/rustdesk
    patchelf --add-rpath "${pkgs.xdotool}/lib" $out/app/rustdesk/rustdesk
    patchelf --add-rpath "${pkgs.xdotool}/lib" $out/app/rustdesk/lib/librustdesk.so
  '';

  syncScript = pkgs.writeShellScript "rustdesk-sync-config" ''
    USER_CONFIG="/home/${cfg.service.user}/.config/rustdesk"

    # 1. Sync config to root so the system service has custom relay, ID, keypair, and permanent password
    mkdir -p /root/.config/rustdesk || true
    if [ -f "$USER_CONFIG/RustDesk.toml" ]; then
      cp -f "$USER_CONFIG/RustDesk.toml" /root/.config/rustdesk/ || true
      cp -f "$USER_CONFIG/RustDesk2.toml" /root/.config/rustdesk/ || true
      chmod 600 /root/.config/rustdesk/*.toml || true
    fi

    # 2. Sync config to lightdm so the greeter session has the exact same ID and relay server
    if [ -d "/var/lib/lightdm" ]; then
      mkdir -p /var/lib/lightdm/.config/rustdesk || true
      if [ -f "$USER_CONFIG/RustDesk.toml" ]; then
        cp -f "$USER_CONFIG/RustDesk.toml" /var/lib/lightdm/.config/rustdesk/ || true
        cp -f "$USER_CONFIG/RustDesk2.toml" /var/lib/lightdm/.config/rustdesk/ || true
        chown -R lightdm:lightdm /var/lib/lightdm/.config || true
        chmod 600 /var/lib/lightdm/.config/rustdesk/*.toml || true
      fi
      mkdir -p /var/lib/lightdm/.local/share/logs/RustDesk || true
      chown -R lightdm:lightdm /var/lib/lightdm/.local || true
    fi

    # 3. Sync X11 authorization from LightDM if it is active
    if [ -f /var/run/lightdm/root/:0 ]; then
      cp -f /var/run/lightdm/root/:0 /root/.Xauthority || true
      chmod 600 /root/.Xauthority || true
      if [ -d /var/lib/lightdm ]; then
        cp -f /var/run/lightdm/root/:0 /var/lib/lightdm/.Xauthority || true
        chown lightdm:lightdm /var/lib/lightdm/.Xauthority || true
        chmod 600 /var/lib/lightdm/.Xauthority || true
      fi
    fi
  '';
in
{
  options.modules.rustdesk = {
    enable = mkEnableOption "rustdesk remote desktop";

    package = mkOption {
      type = types.package;
      default = rustdeskPatched;
      description = "The rustdesk package to use";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to open firewall ports for RustDesk direct and relay connections";
    };

    service = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the RustDesk systemd service for unattended access";
      };

      user = mkOption {
        type = types.str;
        default = "delos";
        description = "Primary user whose RustDesk credentials and server settings should be synced for unattended boot access";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      pkgs.xhost
      pkgs.xdotool
    ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 21118 ];
      allowedUDPPorts = [ 21116 21119 ];
    };

    # Enable uinput device access for input injection
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    '';

    # Give primary user and lightdm user access to video and input groups
    users.users = {
      ${cfg.service.user}.extraGroups = [ "input" ];
    } // (lib.optionalAttrs (config.services.xserver.displayManager.lightdm.enable or false) {
      lightdm.extraGroups = [ "video" "render" "input" ];
    });

    # Grant root, lightdm, and primary user access to the X11 display upon display manager start
    services.xserver.displayManager.setupCommands = mkIf (config.services.xserver.enable or false) ''
      ${pkgs.xhost}/bin/xhost +SI:localuser:root || true
      if id lightdm &>/dev/null; then
        ${pkgs.xhost}/bin/xhost +SI:localuser:lightdm || true
      fi
      if id ${cfg.service.user} &>/dev/null; then
        ${pkgs.xhost}/bin/xhost +SI:localuser:${cfg.service.user} || true
      fi
      if [ -f /var/run/lightdm/root/:0 ]; then
        mkdir -p /var/lib/lightdm
        cp -f /var/run/lightdm/root/:0 /var/lib/lightdm/.Xauthority || true
        cp -f /var/run/lightdm/root/:0 /root/.Xauthority || true
        chown lightdm:lightdm /var/lib/lightdm/.Xauthority || true
        chmod 600 /var/lib/lightdm/.Xauthority || true
      fi
    '';

    systemd.services.rustdesk = mkIf cfg.service.enable {
      description = "RustDesk";
      wants = [
        "network-online.target"
        "display-manager.service"
      ];
      after = [
        "network-online.target"
        "display-manager.service"
        "systemd-user-sessions.service"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [
        "/run/wrappers"
        "/run/current-system/sw"
        pkgs.coreutils
        pkgs.procps
        pkgs.gnugrep
        pkgs.gnused
        pkgs.gawk
        pkgs.which
        pkgs.xrandr
        pkgs.xauth
        pkgs.xhost
        pkgs.xdotool
        pkgs.systemd
        cfg.package
      ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${syncScript}";
        ExecStart = "${cfg.package}/bin/rustdesk --service";
        ExecStop = "${pkgs.procps}/bin/pkill -f 'rustdesk --'";
        Restart = "always";
        RestartSec = 2;
        PIDFile = "/run/rustdesk.pid";
        KillMode = "mixed";
        TimeoutStopSec = 30;
        User = "root";
        LimitNOFILE = 100000;
      };
      environment = {
        PULSE_LATENCY_MSEC = "60";
        PIPEWIRE_LATENCY = "1024/48000";
        DISPLAY = ":0";
      };
    };
  };
}
