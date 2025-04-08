{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editors.vscode;
in {
  options.modules.editors.vscode = {
    enable = mkEnableOption "vscode configuration";
    
    extensions = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional VSCode extensions to install";
    };
    
    userSettings = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional VSCode user settings";
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      
      # Choose between VSCode and VSCodium
      package = pkgs.vscodium;
      
      # Extensions to install
      extensions = with pkgs.vscode-extensions; [
        # Theme
        dracula-theme.theme-dracula
        
        # Languages
        bbenoist.nix
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        ms-python.python
        golang.go
        
        # General
        vscodevim.vim
        eamodio.gitlens
        esbenp.prettier-vscode
        editorconfig.editorconfig
        dbaeumer.vscode-eslint
        
        # Utilities
        streetsidesoftware.code-spell-checker
        gruntfuggly.todo-tree
      ] ++ cfg.extensions;
      
      # User settings
      userSettings = {
        # Editor settings
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 24;
        "editor.renderWhitespace" = "boundary";
        "editor.rulers" = [ 80 120 ];
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = true;
          "source.organizeImports" = true;
        };
        
        # Workbench settings
        "workbench.colorTheme" = "Dracula";
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.sideBar.location" = "left";
        "workbench.tree.indent" = 16;
        
        # Window settings
        "window.zoomLevel" = 0;
        "window.titleBarStyle" = "custom";
        
        # Files settings
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.exclude" = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/*.o" = true;
          "**/*.so" = true;
          "**/*.class" = true;
          "**/node_modules" = true;
          "**/.classpath" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/.factorypath" = true;
        };
        "files.associations" = {
          "*.nix" = "nix";
          "flake.lock" = "json";
        };
        
        # Terminal settings
        "terminal.integrated.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        "terminal.integrated.fontSize" = 14;
        
        # Git settings
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        
        # Language-specific settings
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.formatOnSave" = true;
        };
        
        "[rust]" = {
          "editor.tabSize" = 4;
          "editor.formatOnSave" = true;
        };
        
        "[python]" = {
          "editor.tabSize" = 4;
          "editor.formatOnSave" = true;
        };
        
        "[javascript][typescript][javascriptreact][typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.tabSize" = 2;
          "editor.formatOnSave" = true;
        };
        
        # Extension settings
        "todo-tree.general.tags" = [
          "BUG",
          "HACK",
          "FIXME",
          "TODO",
          "XXX",
          "[ ]",
          "[x]"
        ];
        
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
      } // cfg.userSettings;
      
      # Key bindings
      keybindings = [
        {
          key = "ctrl+p";
          command = "workbench.action.quickOpen";
        }
        {
          key = "ctrl+shift+p";
          command = "workbench.action.showCommands";
        }
        {
          key = "ctrl+shift+e";
          command = "workbench.view.explorer";
        }
        {
          key = "ctrl+shift+g";
          command = "workbench.view.scm";
        }
        {
          key = "ctrl+shift+x";
          command = "workbench.view.extensions";
        }
        {
          key = "ctrl+shift+f";
          command = "workbench.action.findInFiles";
        }
        {
          key = "ctrl+`";
          command = "workbench.action.terminal.toggleTerminal";
        }
      ];
    };
  };
}