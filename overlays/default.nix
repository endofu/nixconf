# This file defines overlays
{  ... }:

{
  # This allows defining custom packages in the pkgs directory
  additions = final: prev: import ../pkgs { pkgs = final; };

  # This allows overriding existing packages with custom modifications
  modifications = final: prev: {
    # Example: override neovim to add plugins
    neovim = prev.neovim.override {
      configure = {
        customRC = ''
          " Additional neovim configuration
        '';
        packages.myPlugins = with prev.vimPlugins; {
          start = [ 
            vim-nix 
            vim-lastplace
            vim-signify
          ];
          opt = [];
        };
      };
    };
  };

  # Apply nixpkgs.config to the system
  config = final: prev: {
    inherit (import ../pkgs/config.nix) config;
  };
}