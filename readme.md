# Modular Nix Configuration

A comprehensive and modular Nix configuration for managing NixOS, Nix Darwin, and Home Manager across multiple machines.

## Architecture

This repository uses a modular architecture that separates concerns:

-   **Hosts** (`hosts/`): Machine-specific configurations for NixOS and macOS.
-   **Modules** (`modules/`): Reusable system-level modules (common, darwin, nixos).
-   **Home Manager** (`home/`): User-level configuration, profiles, and user-space modules.
-   **Secrets** (`secrets/`): Encrypted secrets managed via `sops-nix`.

## Supported Systems

### macOS (Nix Darwin)
-   **samos**: M1 Ultra Mac Studio (Workstation)
-   **arcadia**: Intel MacBook Pro (Legacy/Remote)

### NixOS (Linux)
-   **sparta**: Desktop/Server
-   **elaine**: Workstation
-   **delos**: Server/Testing

## Getting Started

### Prerequisites

-   **Nix**: Flakes must be enabled.
-   **Determinate Nix**: Highly recommended for macOS users.
-   **Sops-nix & Age**: Required for secret decryption.

### Usage

This project prefers the `nh` CLI for system switches.

#### Switch Darwin (macOS)
```bash
nh darwin switch .#samos
```

#### Switch NixOS
```bash
sudo nixos-rebuild switch --flake .#sparta
```

## Maintenance

### Updating Inputs
```bash
nix flake update
```

### Checking Configuration
```bash
nix flake check
```

## Repository Structure

```
.
├── flake.nix                # Entry point
├── hosts                    # Machine-specific configurations
│   ├── nixos                # NixOS hosts (sparta, elaine, delos)
│   └── darwin               # Darwin hosts (samos, arcadia)
├── modules                  # Reusable system modules
│   ├── common               # Shared cross-platform (nix-settings, basics, etc.)
│   ├── nixos                # Linux-only
│   └── darwin               # macOS-only
├── home                     # Home Manager configuration
│   ├── profiles             # Composable user profiles
│   ├── modules              # User-space modules
│   └── users                # Per-user configs
└── secrets                  # Encrypted secrets.yaml
```
