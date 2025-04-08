{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.editors.neovim;
in {
  options.modules.editors.neovim = {
    enable = mkEnableOption "neovim configuration";
    
    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to set neovim as the default editor";
    };
    
    plugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional neovim plugins to install";
    };
    
    lsp = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable LSP support";
      };
      
      servers = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of LSP servers to install";
        example = [ "rust-analyzer" "pyright" "tsserver" ];
      };
    };
  };

  config = mkIf cfg.enable {
    # Install neovim and set as default editor if requested
    programs.neovim = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      
      # Use neovim for vim
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      
      # Install plugins
      plugins = with pkgs.vimPlugins; [
        # Core plugins
        nvim-treesitter.withAllGrammars
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = mkIf cfg.lsp.enable ''
            local lspconfig = require('lspconfig')
            
            -- Enable LSP servers
            ${concatMapStringsSep "\n" (server: "lspconfig.${server}.setup {}") cfg.lsp.servers}
            
            -- Global mappings
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
            
            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('UserLspConfig', {}),
              callback = function(ev)
                -- Buffer local mappings
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<space>f', function()
                  vim.lsp.buf.format { async = true }
                end, opts)
              end,
            })
          '';
        }
        vim-nix
        vim-commentary
        vim-surround
        vim-fugitive
        vim-gitgutter
        nvim-web-devicons
        lualine-nvim
        telescope-nvim
        which-key-nvim
        {
          plugin = dracula-nvim;
          config = ''
            colorscheme dracula
          '';
        }
      ] ++ cfg.plugins;
      
      # Extra packages for neovim
      extraPackages = with pkgs; [
        # Core dependencies
        nodejs
        ripgrep
        fd
        
        # For telescope
        gcc
        gnumake
        
        # LSP servers if enabled
      ] ++ optionals cfg.lsp.enable (with pkgs; [
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.bash-language-server
        nodePackages.pyright
        rust-analyzer
        nil # Nix LSP
      ]);
      
      # Extra configuration
      extraConfig = ''
        " Basic settings
        set number
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smartindent
        set nowrap
        set scrolloff=8
        set sidescrolloff=8
        set signcolumn=yes
        set colorcolumn=80
        set termguicolors
        set incsearch
        set nohlsearch
        set splitright
        set splitbelow
        set hidden
        set updatetime=100
        set timeoutlen=500
        
        " Set leader key
        let mapleader = " "
        
        " Key mappings
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>fh <cmd>Telescope help_tags<cr>
      '';
    };
    
    # Add mason.nvim's bin directory to PATH if LSP is enabled
    home.sessionVariables = mkIf cfg.lsp.enable {
      PATH = "$HOME/.local/share/nvim/mason/bin:$PATH";
    };
  };
}