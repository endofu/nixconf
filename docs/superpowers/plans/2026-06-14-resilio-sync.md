# Resilio Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement Resilio Sync modules for NixOS and nix-darwin and enable it on the `arcadia` host.

**Architecture:** A common interface module for shared options, with OS-specific implementations for NixOS (wrapping `services.resilio`) and nix-darwin (using a custom `launchd` agent and JSON config).

**Tech Stack:** Nix, Resilio Sync, launchd (macOS), systemd (NixOS).

---

### Task 1: Create Common Module

**Files:**
- Create: `modules/common/resilio.nix`
- Modify: `modules/common/default.nix`

- [ ] **Step 1: Write `modules/common/resilio.nix`**

```nix
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.resilio;
in
{
  options.modules.resilio = {
    enable = mkEnableOption "Resilio Sync";
    deviceName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "Device name as it will appear in Resilio Sync";
    };
    listeningPort = mkOption {
      type = types.int;
      default = 0;
      description = "Listening port for Resilio Sync (0 for random)";
    };
    webUI = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the Web UI";
      };
      listenAddr = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address for the Web UI to listen on";
      };
      port = mkOption {
        type = types.int;
        default = 8888;
        description = "Port for the Web UI";
      };
    };
  };
}
```

- [ ] **Step 2: Register module in `modules/common/default.nix`**

Add `./resilio.nix` to the `imports` list.

- [ ] **Step 3: Commit**

```bash
git add modules/common/resilio.nix modules/common/default.nix
git commit -m "feat: add common resilio module options"
```

---

### Task 2: Create NixOS Module

**Files:**
- Create: `modules/nixos/resilio.nix`
- Modify: `modules/nixos/default.nix`

- [ ] **Step 1: Write `modules/nixos/resilio.nix`**

```nix
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.resilio;
in
{
  config = mkIf cfg.enable {
    services.resilio = {
      enable = true;
      deviceName = cfg.deviceName;
      listeningPort = cfg.listeningPort;
      enableWebUI = cfg.webUI.enable;
      httpListenAddr = cfg.webUI.listenAddr;
      httpListenPort = cfg.webUI.port;
      storagePath = "/home/arcadia/.rslsync"; # Simplified for arcadia-first assumption, can be generalized later
    };

    # Ensure rslsync package is available if needed, though services.resilio handles it
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "resilio-sync"
    ];
  };
}
```

- [ ] **Step 2: Register module in `modules/nixos/default.nix`**

Add `./resilio.nix` to the `imports` list.

- [ ] **Step 3: Commit**

```bash
git add modules/nixos/resilio.nix modules/nixos/default.nix
git commit -m "feat: add nixos resilio module implementation"
```

---

### Task 3: Create Darwin Module

**Files:**
- Create: `modules/darwin/resilio.nix`
- Modify: `modules/darwin/default.nix`

- [ ] **Step 1: Write `modules/darwin/resilio.nix`**

```nix
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.resilio;
  user = config.system.primaryUser;
  storagePath = "/Users/${user}/.rslsync";
  
  syncConfig = pkgs.writeText "sync.conf" (builtins.toJSON {
    device_name = cfg.deviceName;
    storage_path = storagePath;
    listening_port = cfg.listeningPort;
    check_for_updates = false;
    use_upnp = true;
    webui = if cfg.webUI.enable then {
      listen = "${cfg.webUI.listenAddr}:${toString cfg.webUI.port}";
    } else null;
  });
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.resilio-sync ];

    launchd.user.agents.resilio-sync = {
      command = "${pkgs.resilio-sync}/bin/rslsync --nodaemon --config ${syncConfig}";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/resilio-sync.out.log";
        StandardErrorPath = "/tmp/resilio-sync.err.log";
      };
    };

    # Ensure storage path exists
    system.activationScripts.extraActivation.text = ''
      echo "ensuring resilio storage path exists..."
      mkdir -p ${storagePath}
      chown ${user} ${storagePath}
    '';
  };
}
```

- [ ] **Step 2: Register module in `modules/darwin/default.nix`**

Add `./resilio.nix` to the `imports` list.

- [ ] **Step 3: Commit**

```bash
git add modules/darwin/resilio.nix modules/darwin/default.nix
git commit -m "feat: add darwin resilio module implementation"
```

---

### Task 4: Enable on Arcadia

**Files:**
- Modify: `hosts/darwin/arcadia/default.nix`

- [ ] **Step 1: Enable `modules.resilio`**

Add `resilio.enable = true;` to the `modules` block.

- [ ] **Step 2: Run dry-run to verify nix-darwin config**

Run: `darwin-rebuild build --flake .#arcadia`
Expected: Successful build.

- [ ] **Step 3: Commit**

```bash
git add hosts/darwin/arcadia/default.nix
git commit -m "conf: enable resilio sync on arcadia"
```

---

### Task 5: Verification

- [ ] **Step 1: Verify service status (post-activation)**

Run: `launchctl list | grep resilio`
Expected: Service is listed and running.

- [ ] **Step 2: Verify Web UI**

Run: `curl -I http://127.0.0.1:8888`
Expected: 200 OK or Redirect to login.

- [ ] **Step 3: Verify storage path**

Run: `ls -d ~/.rslsync`
Expected: Directory exists.
