# Design Doc: Resilio Sync Implementation

Add Resilio Sync to both NixOS and nix-darwin setups, with a focus on consistency and ease of use.

## Architecture

The implementation will be split into three modules to handle cross-platform differences while providing a unified interface.

### 1. Common Module (`modules/common/resilio.nix`)
- Defines the common configuration options under `modules.resilio`.
- Options:
  - `enable`: Boolean
  - `deviceName`: String (defaults to `networking.hostName`)
  - `listeningPort`: Int (defaults to `0` for random)
  - `webUI`:
    - `enable`: Boolean (defaults to `true`)
    - `listenAddr`: String (defaults to `127.0.0.1`)
    - `port`: Int (defaults to `8888`)

### 2. NixOS Module (`modules/nixos/resilio.nix`)
- Maps `modules.resilio` options to the native `services.resilio` NixOS module.
- Configures `services.resilio.storagePath` to `~/.rslsync` (handled via the service user's home or explicit path).
- Note: NixOS runs Resilio as `rslsync` user by default. We will ensure the user is in the `rslsync` group.

### 3. Darwin Module (`modules/darwin/resilio.nix`)
- Custom implementation for macOS.
- Uses `pkgs.resilio-sync`.
- Configures a `launchd.user.agents.resilio-sync` to run the binary as the logged-in user.
- Generates a declarative JSON config file passed via `--config`.
- Sets `storage_path` to `~/Users/<user>/.rslsync`.

## Storage Strategy
- Metadata/Database: `~/.rslsync` on both platforms for consistency and visibility.

## Implementation Plan
1. Create `modules/common/resilio.nix` with option definitions.
2. Create `modules/nixos/resilio.nix` for NixOS mapping.
3. Create `modules/darwin/resilio.nix` for Darwin implementation.
4. Update `modules/common/default.nix`, `modules/nixos/default.nix`, and `modules/darwin/default.nix` to include the new modules.
5. Enable `modules.resilio.enable = true` in `hosts/darwin/arcadia/default.nix`.
6. Verify implementation.

## Success Criteria
- Resilio Sync binary is installed on `arcadia`.
- A `launchd` agent is running `rslsync`.
- The Web UI is accessible on `localhost:8888`.
- Metadata is stored in `~/.rslsync`.
