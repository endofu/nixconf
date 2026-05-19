# TODO - Nix Configuration Improvements

A comprehensive list of issues, improvements, and refactoring opportunities identified in this repository.

---

## High Priority Issues

### 1. ~~Incomplete LLM Module Refactor~~ (COMPLETED)
- [x] Complete the refactor moving LLM from common to platform-specific
- [x] `modules/nixos/llm.nix` - NixOS service-based config with ollama.cuda option
- [x] `modules/darwin/llm.nix` - Darwin config using Homebrew cask for ollama

### 2. Duplicated Configuration Across Users
- [ ] All users have nearly identical SSH configuration (migrated to `programs.ssh.settings` but still duplicated)
- [ ] Git username/email ("endofu") repeated in all user configs
- [ ] **Action**: Extract to a shared base profile or home module

### 3. Duplicated Shell Variables & Secrets Export
- [ ] `GITHUB_TOKEN` export is repeated in all host `shellInit` blocks
- [ ] **Action**: Consolidate secrets export to a common module that handles platform-specific shell init

### 4. Duplicate Shell Aliases
- [ ] `home/modules/shell/zsh.nix` and `home/modules/shell/utilities.nix` define overlapping aliases
- [ ] **Action**: Consolidate to single location

---

## Dead Code & Cleanup

### 5. ~~Duplicate Nix Settings~~ (COMPLETED)
- [x] Consolidate `nix.settings` and `nix.extraOptions` to `modules/common/nix-settings.nix`
- [x] Fixed conflict with Determinate Nix on Darwin by using `nix.enable = false` and `extraOptions`

### 6. Commented Code in flake.nix
- [ ] Lines 31-37: Unused `supportedSystems` and `forAllSystems`
- [ ] Lines 119-135: Unused `packages` and `devShells` exports
- [ ] **Action**: Remove or implement

### 7. Consolidate TODO Files
- [ ] `todos.md` and `TODO.md` are redundant
- [ ] **Action**: Move remaining relevant items from `todos.md` to `TODO.md` and delete `todos.md`

---

## Structural Improvements

### 8. Hardcoded User Paths
- [ ] Several hosts use hardcoded paths like `/Users/samos/.config/sops/age/keys.txt`
- [ ] **Action**: Use `${config.users.users.<name>.home}/.config/sops/age/keys.txt`

### 9. Duplicate Secrets Configuration
- [ ] All hosts have nearly identical `sops.secrets` setup for API keys
- [ ] **Action**: Create a shared secrets module with granular toggles

### 10. Standardize Platform Checks
- [ ] Many files still use `pkgs.stdenv.isDarwin` which is being deprecated in favor of `pkgs.stdenv.hostPlatform.isDarwin`
- [ ] **Action**: Run a global replace for `stdenv.isLinux` and `stdenv.isDarwin`

### 11. Inconsistent State Versions
- [ ] stateVersion varies between hosts and home-manager configs
- [ ] **Action**: Standardize or document reasons for differences

---

## Module Design & Quality

### 12. Modules That Are Just Package Lists
- [ ] `modules/common/{claude-code,ffmpeg,vnc}.nix` only add packages
- [ ] **Action**: Consolidate into a unified `packages.nix`

### 13. Magic String App IDs
- [ ] `home/modules/darwin/aerospace.nix` uses hardcoded app IDs (e.g., `com.apple.finder`)
- [ ] **Action**: Extract to a data structure

### 14. TODO Comments in Code
- [ ] `modules/nixos/server.nix:103`, `hosts/nixos/sparta/default.nix:78`, etc.
- [ ] **Action**: Resolve these inline TODOs

---

## Refactoring Opportunities

### 15. Create a Base Home Profile
- [ ] Extract common configuration (SSH settings, Git identity, common variables) into `profiles/base.nix`

### 16. Server Profile Missing
- [ ] No home-manager profile for server users who don't need desktop features
- [ ] **Action**: Create `profiles/server.nix`

### 17. Firefox Configuration Cleanup
- [ ] `home/profiles/nixos.nix` Firefox conditional is redundant
- [ ] **Action**: Simplify to `programs.firefox.enable = true;`

---

## Documentation

### 18. README Updates Needed
- [ ] README references old host names (`laptop`, `macbook`)
- [ ] **Action**: Update with `sparta`, `elaine`, `delos`, `arcadia`, `samos`

### 19. Module Documentation
- [ ] Modules lack header comments explaining purpose and requirements
- [ ] **Action**: Add documentation headers to all modules
