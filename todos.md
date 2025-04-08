# TODOs for Nix Configuration

This document outlines pending tasks and improvements for this Nix configuration setup.

## High Priority

- [ ] Add CI/CD integration for testing configurations (GitHub Actions or similar)
- [ ] Set up secrets management with either `agenix` or `sops-nix`
- [ ] Create hardware-configuration.nix examples for common hardware setups
- [ ] Implement a script to bootstrap new systems more easily

## Medium Priority

- [ ] Add more specialized home-manager modules:
  - [ ] Development environment module for languages like Rust, Python, Node.js
  - [ ] Gaming module for Steam, Lutris, etc.
  - [ ] Creative tools module for design and content creation
- [ ] Improve the documentation with examples and troubleshooting tips
- [ ] Create specialized server modules (media server, homelab, etc.)
- [ ] Add containerization support (Docker, Podman configurations)
- [ ] Create more custom package examples

## Low Priority

- [ ] Add theme switching capabilities
- [ ] Implement command-line tools for common configuration tasks
- [ ] Create a wiki for advanced usage and recipes
- [ ] Add example configurations for specialized hardware (GPUs, IoT devices)
- [ ] Optimize rebuild times for large configurations
- [ ] Add Nix tests to verify configurations

## User Experience Improvements

- [ ] Improve onboarding process for new users
- [ ] Create a guided setup script
- [ ] Add more example configurations for inspiration
- [ ] Create visual documentation of available desktop setups

## System Modules to Consider Adding

- [ ] Backup module
- [ ] Security hardening module
- [ ] Virtualization module
- [ ] Remote development module
- [ ] Home automation module

## Maintenance

- [ ] Regularly update flake inputs
- [ ] Audit module options for consistency
- [ ] Test configurations on various hardware
- [ ] Verify compatibility with latest NixOS/nix-darwin versions
