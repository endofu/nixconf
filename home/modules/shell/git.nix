{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = mkEnableOption "git configuration";
    
    userName = mkOption {
      type = types.str;
      default = "";
      description = "Git user name";
      example = "John Doe";
    };
    
    userEmail = mkOption {
      type = types.str;
      default = "";
      description = "Git user email";
      example = "john@example.com";
    };
    
    signing = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable commit signing";
      };
      
      key = mkOption {
        type = types.str;
        default = "";
        description = "GPG key to use for signing";
      };
    };
    
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Git aliases";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      
      userName = mkIf (cfg.userName != "") cfg.userName;
      userEmail = mkIf (cfg.userEmail != "") cfg.userEmail;
      
      signing = mkIf cfg.signing.enable {
        key = cfg.signing.key;
        signByDefault = true;
      };
      
      aliases = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      } // cfg.aliases;

      difftastic = {
        enable = true;
        # enableAsDifftool = true;
      };
      
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        column.ui = "auto";
        branch.sort = "committerdate";
        tag.sort = "version:refname";
        # init.defaultBranch = "main";
        diff = {
          # external = "difft";
          # algorithm = "histogram";
          # colorMoved = "plain";
          # mnemonicPrefix = true;
          # renames = true;
        };
        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        core = {
          editor = "nvim";
          whitespace = "trailing-space,space-before-tab";
        };
        color = {
          ui = "auto";
        };
#         diff = {
#           colorMoved = "default";
#         };
        merge = {
          conflictStyle = "diff3";
        };
      };
      
      ignores = [
        # OS specific
        ".DS_Store"
        "Thumbs.db"
        
        # Editor files
        ".vscode/"
        ".idea/"
        "*.swp"
        "*.swo"
        "*~"
        
        # Common build directories
        "build/"
        "dist/"
        "target/"
        "result"
        "result-*"
        
        # Dependencies
        "node_modules/"
        ".pnp/"
        ".pnp.js"
        
        # Logs
        "logs/"
        "*.log"
        "npm-debug.log*"
        "yarn-debug.log*"
        "yarn-error.log*"
        
        # Environments
        ".env"
        ".env.local"
        ".env.development.local"
        ".env.test.local"
        ".env.production.local"
        
        # Direnv
        ".direnv/"
        ".envrc"
      ];
    };
    
    # Add delta for better diffs if available
#     programs.git.delta = {
#       enable = true;
#       options = {
#         features = "side-by-side line-numbers decorations";
#         syntax-theme = "Dracula";
#         plus-style = "syntax #003800";
#         minus-style = "syntax #3f0001";
#       };
#     };
  };
}
