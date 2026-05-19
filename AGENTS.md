# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) and Gemini CLI when working with code in this repository.

## Task Tracking

Use `TODO.md` for tracking tasks and improvements in this project. When identifying new issues or tasks, add them to the appropriate section in `TODO.md`.

## Overview

This is a modular Nix configuration repository managing both NixOS and macOS (nix-darwin) systems with shared home-manager setups. The configuration uses Nix flakes and follows a modular architecture that separates concerns across hosts, modules, and profiles.

## Build and Deploy Commands

### NixOS Systems
```bash
# Build and activate configuration (requires sudo)
sudo nixos-rebuild switch --flake .#<hostname>

# Available hosts: elaine, sparta, delos
sudo nixos-rebuild switch --flake .#sparta
```

### Darwin (macOS) Systems
```bash
# Using nh (preferred)
nh darwin switch ~/Code/nixconf#darwinConfigurations.<hostname>

# Available hosts: arcadia, samos
nh darwin switch ~/Code/nixconf#darwinConfigurations.samos

# Legacy way (not recommended for Determinate Nix setups)
# darwin-rebuild switch --flake .#<hostname>
```

### Testing Changes
```bash
# Build without activating (NixOS)
nixos-rebuild build --flake .#<hostname>

# Build without activating (Darwin)
nh darwin build ~/Code/nixconf#darwinConfigurations.<hostname>
```

## Repository Architecture

### 1. Hosts (Machine-Specific Configuration)
Located in `hosts/{nixos,darwin}/<hostname>/default.nix`. Each host configuration:
- Defines the specific machine (hostname, platform, hardware)
- Enables/disables modules via the `modules.<name>.enable` pattern
- Assigns users to the machine
- Manages secrets via sops-nix
- On Darwin: `nix.enable = false` is set to maintain compatibility with Determinate Nix

### 2. Modules (Reusable System Configuration)
Located in `modules/{common,darwin,nixos}/`.
- **Common modules** (`modules/common/`): Cross-platform settings (nix-settings, basics, fonts, claude-code, etc.)
- **Darwin modules** (`modules/darwin/`): macOS-specific (homebrew, macos settings, etc.)
- **NixOS modules** (`modules/nixos/`): Linux-specific (desktop, server, etc.)

All modules follow the `options.modules.<name>.enable` pattern.

### 3. Home-Manager (User-Level Configuration)
Located in `home/`:
- **Profiles** (`home/profiles/`): Composable sets of functionality (developer, desktop, etc.)
- **Users** (`home/users/<username>/default.nix`): Per-user configuration importing profiles
- **Modules** (`home/modules/`): User-space modules (shell, editors, etc.)

## Secrets Management

Secrets are managed via sops-nix:
- Secret file: `secrets/secrets.yaml` (encrypted)
- AGE keys: `~/.config/sops/age/keys.txt`
- Secrets must have an `owner` set to the primary user to be accessible in user shells.

### GitHub Token & Rate Limiting
To avoid GitHub API rate limits during flake operations, a `github_token` is stored in sops and automatically exported as `GITHUB_TOKEN` in host shell initializations.

Example from `hosts/darwin/samos/default.nix`:
```nix
sops.secrets.github_token = { owner = "samos"; };
programs.zsh.shellInit = ''
  export GITHUB_TOKEN="$(cat /run/secrets/github_token)"
'';
```

## Key Flake Inputs

- `nixpkgs`: Primary package source (nixpkgs-unstable)
- `darwin`: nix-darwin framework for macOS
- `home-manager`: User environment management (follows `nixpkgs`)
- `sops-nix`: Secrets management (follows `nixpkgs`)

## Important Files

- `flake.nix`: Entry point defining all system configurations
- `flake.lock`: Pinned input versions
- `modules/common/nix-settings.nix`: Shared Nix daemon settings and experimental features
- `hosts/`: Per-machine configuration
- `TODO.md`: Task tracking and improvement backlog
