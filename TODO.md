# TODO - Nix Configuration Improvements

A comprehensive list of issues, improvements, and refactoring opportunities identified in this repository.

---

## High Priority Issues

### 1. ~~Incomplete LLM Module Refactor~~ (COMPLETED)
- [x] Complete the refactor moving LLM from common to platform-specific
- [x] `modules/nixos/llm.nix` - NixOS service-based config with ollama.cuda option
- [x] `modules/darwin/llm.nix` - Darwin config using Homebrew cask for ollama
- [x] Both modules now share consistent option patterns (modules.llm.enable, modules.llm.ollama.enable)

### 2. Duplicated Configuration Across Users
- [ ] All 4 users (samos, arcadia, elaine, sparta) have nearly identical SSH configuration
- [ ] Git username/email ("endofu") repeated in all user configs
- [ ] Profile import patterns duplicated
- [ ] **Action**: Extract to a shared base profile or home module

### 3. Duplicated Shell Variables
- [ ] `home/modules/shell/zsh.nix` and `home/modules/shell/bash.nix` both define identical `sessionVariables`
- [ ] **Action**: Define once in a common shell module

### 4. Duplicate Shell Aliases
- [ ] `home/modules/shell/zsh.nix:49-54` defines aliases (ls, cat, mc)
- [ ] `home/modules/shell/utilities.nix` defines the same aliases
- [ ] **Action**: Consolidate to single location

### 5. Indentation Inconsistency
- [ ] `modules/nixos/desktop.nix:49-50` mixes tabs and spaces
- [ ] **Action**: Fix to use consistent spacing

---

## Dead Code to Remove

### 6. Commented Code in flake.nix
- [ ] Lines 31-37: Unused `supportedSystems` and `forAllSystems`
- [ ] Lines 119-135: Unused `packages` and `devShells` exports
- [ ] **Action**: Remove or implement

### 7. Completely Disabled Module
- [ ] `home/modules/editors/opencode.nix:20-34` - entire configuration is commented out
- [ ] **Action**: Remove module or implement properly

### 8. Unused Custom Package
- [ ] `pkgs/custom-neofetch/` exists but is commented out in `pkgs/default.nix`
- [ ] **Action**: Remove or re-enable

### 9. Unused Overlay
- [ ] `overlays/default.nix:11-26` - neovim override is commented out
- [ ] **Action**: Remove or implement

### 10. Dead Configuration Options
- [ ] `home/modules/shell/utilities.nix`: `enableExa` option exists but exa alias is commented out
- [ ] `home/modules/shell/bash.nix`: Empty `shellAliases = {}`
- [x] ~~Both LLM modules: `open-webui.enable = false`~~ - Now a proper configurable option in NixOS module
- [ ] **Action**: Clean up unused options

### 11. Commented Git Diff Tools
- [ ] `home/modules/shell/git.nix:115-185` - difftastic and delta configurations commented out
- [ ] **Action**: Remove or implement

---

## Structural Improvements

### 12. Hardcoded User Paths
- [ ] `hosts/darwin/samos/default.nix:62` uses `/Users/samos/.config/sops/age/keys.txt`
- [ ] **Action**: Use `${config.users.users.samos.home}/.config/sops/age/keys.txt`

### 13. Duplicate Nix Settings
- [ ] `modules/darwin/darwin-basics.nix` has `nix.settings`
- [ ] `modules/nixos/nix-settings.nix` has `nix.settings`
- [ ] Both define nearly identical experimental-features, warn-dirty, max-jobs
- [ ] **Action**: Consolidate to `modules/common/nix-settings.nix`

### 14. Duplicate Secrets Configuration
- [ ] Both Darwin hosts have identical sops secrets setup
- [ ] Repeated zsh.shellInit for API keys
- [ ] **Action**: Create a shared secrets module

### 15. Missing Platform Auto-Selection
- [ ] Users manually import platform profiles (`darwin.nix` or `nixos.nix`)
- [ ] **Action**: Auto-select based on `pkgs.stdenv.isDarwin`

### 16. Inconsistent State Versions
- [ ] samos: `"25.11"`
- [ ] arcadia, elaine, sparta: `"24.11"`
- [ ] **Action**: Document why they differ or make consistent

---

## Module Design Issues

### 17. Modules That Are Just Package Lists
- [ ] `modules/common/claude-code.nix` - only adds packages
- [ ] `modules/common/ffmpeg.nix` - only adds packages
- [ ] `modules/common/vnc.nix` - only adds packages
- [ ] **Action**: Consolidate into `packages.nix` with granular enable options

### 18. Magic String App IDs
- [ ] `home/modules/darwin/aerospace.nix` uses hardcoded app IDs
- [ ] Examples: `com.apple.finder`, `com.mitchellh.ghostty`
- [ ] **Action**: Extract to a data structure for maintainability

### 19. Missing Module Dependencies
- [x] ~~`modules/darwin/llm.nix` depends on Homebrew~~ - Now uses `homebrew.casks` directly (implicit dependency)
- [ ] `modules/nixos/desktop.nix` logically depends on fonts
- [ ] **Action**: Document or enforce dependencies

### 20. Karabiner Overlay at Module Level
- [ ] `modules/darwin/karabiner.nix` applies an overlay inside the module
- [ ] **Action**: Move to flake level to avoid conflicts

### 21. Inconsistent Option Defaults
- [ ] `git.userName = ""` - should perhaps error if not set when enabled
- [ ] `tmux.shell = ""` - should default to system shell
- [ ] **Action**: Add sensible defaults or validation

---

## Code Quality Issues

### 22. TODO Comments in Code
- [ ] `modules/nixos/server.nix:103`: "TODO: move this to mosquitto config"
- [ ] `hosts/nixos/sparta/default.nix:78`: "TODO: move this to module"
- [ ] `hosts/nixos/elaine/default.nix:82`: "TODO: move this to module"
- [ ] **Action**: Complete or remove these TODOs

### 23. Inconsistent Module Naming
- [ ] Most use kebab-case: `modules.basics`, `modules.macos-apps`
- [ ] Some differ: `modules.cloudCode`, `modules.ffmpeg`
- [ ] **Action**: Standardize on kebab-case

### 24. Repeated Conditional Package Pattern
- [ ] `modules/nixos/server.nix` repeats `++ optionals cfg.services.X [pkg]` 5 times
- [ ] **Action**: Create a helper function

### 25. Potentially Missing Dotfiles
- [ ] `home/modules/shell/utilities.nix:110-112` references:
  - `../../dotfiles/ajnasz-blue.ini`
  - `../../dotfiles/mc.ini`
  - `../../dotfiles/ghostty/config`
- [ ] **Action**: Verify files exist or make optional

---

## Refactoring Opportunities

### 26. Create a Base Home Profile
- [ ] Extract common configuration from all users into `profiles/base.nix`:
  - SSH configuration
  - Git identity
  - Common session variables
  - Platform detection logic

### 27. Consolidate Platform-Specific Home Modules
- [ ] Instead of separate `home/modules/darwin/` and `home/modules/nixos/`:
  - Use `mkIf pkgs.stdenv.isDarwin` within single modules
  - Or auto-import based on platform in profile

### 28. Desktop Profile is Too Sparse
- [ ] `home/profiles/desktop.nix` only enables obsidian
- [ ] **Action**: Include more desktop apps or rename to `obsidian.nix`

### 29. Minimal Profile Naming
- [ ] `home/profiles/minimal.nix` isn't particularly minimal
- [ ] **Action**: Rename to `base.nix` or `default.nix`

### 30. Server Profile Missing
- [ ] No home-manager profile for server users who don't need desktop features
- [ ] **Action**: Create `profiles/server.nix`

---

## Potential Bugs

### 31. Firefox Conditional is Redundant
- [ ] `home/profiles/nixos.nix:16`: `programs.firefox.enable = pkgs.stdenv.isLinux;`
- [ ] This is always true in a NixOS profile
- [ ] **Action**: Simplify to `programs.firefox.enable = true;`

### 32. Module Enable Inconsistency
- [ ] Some modules nest enables deeply: `modules.server.sshd.enable`
- [ ] Others are flat: `modules.basics.enable`
- [ ] **Action**: Decide on consistent pattern and document it

---

## Documentation

### 33. No Module Documentation
- [ ] Modules lack comments explaining:
  - What the module does
  - Prerequisites
  - Conflicts with other modules
  - Required secrets
- [ ] **Action**: Add header comments to each module

### 34. README Updates Needed
- [ ] README references `#laptop` and `#macbook` as example hosts
- [ ] Actual hosts are `sparta`, `elaine`, `arcadia`, `samos`
- [ ] **Action**: Update README with correct examples

---

## Priority Guide

**Start with:**
1. Items 1-5 (High Priority Issues)
2. Items 6-11 (Dead Code Removal)
3. Item 22 (Existing TODOs in code)

**Then tackle:**
- Items 12-16 (Structural Improvements)
- Items 26-30 (Refactoring)

**Finally:**
- Items 17-21, 23-25 (Module Design & Code Quality)
- Items 31-34 (Bugs & Documentation)
