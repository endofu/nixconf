{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "darwin";
    };

    # # Homebrew integration
    # nix-homebrew = {
    #   url = "github:zhaofengli-wip/nix-homebrew";
    # };

    # # Optional: Declarative tap management
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    # homebrew-bundle = {
    #   url = "github:homebrew/homebrew-bundle";
    #   flake = false;
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      # nixpkgs-stable,
      darwin,
      home-manager,
      # nix-homebrew,
      # homebrew-core,
      # homebrew-cask,
      # homebrew-bundle,
      ...
    }@inputs:
    let
      # supportedSystems = [
      #   "x86_64-linux"
      #   "aarch64-linux"
      #   "x86_64-darwin"
      #   "aarch64-darwin"
      # ];
      # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # NixOS configuration helpers
      nixosSystem =
        system: hostname: modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nixos/${hostname}
            ./modules/nixos
            ./modules/common
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit self;
              };
            }
          ] ++ modules;
          specialArgs = {
            inherit inputs;
            inherit self;
          };
        };

      # Darwin configuration helpers
      darwinSystem =
        system: hostname: modules:
          darwin.lib.darwinSystem {
            inherit system;
            modules = [
              {
                nixpkgs.overlays = [
                  (final: prev: {
                    nodejs_20 = inputs.nixpkgs-2411.legacyPackages.${system}.nodejs_20;
                  })
                ];
              }
            ./hosts/darwin/${hostname}
            ./modules/darwin
            ./modules/common
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit self;
              };
            }
            # Homebrew integration
            # nix-homebrew.darwinModules.nix-homebrew
            # {
            #   nix-homebrew = {
            #     enable = true;
            #     user = hostname;
            #     taps = {
            #       "homebrew/homebrew-core" = homebrew-core;
            #       "homebrew/homebrew-cask" = homebrew-cask;
            #       "homebrew/homebrew-bundle" = homebrew-bundle;
            #     };
            #     mutableTaps = false;
            #   };
            # }
          ] ++ modules;

          specialArgs = {
            inherit inputs;
            inherit self;
            inherit system;
          };
        };
    in
    {
      # NixOS configurations
      nixosConfigurations = {
        elaine = nixosSystem "x86_64-linux" "elaine" [ ];
      };

      # Darwin configurations
      darwinConfigurations = {
        arcadia = darwinSystem "x86_64-darwin" "arcadia" [ ];
      };

      # # Custom packages
      # packages = forAllSystems (
      #   system:
      #   import ./pkgs {
      #     pkgs = nixpkgs.legacyPackages.${system};
      #   }
      # );

      # Development shell
      # devShells = forAllSystems (system: {
      #   default = nixpkgs.legacyPackages.${system}.mkShell {
      #     packages = with nixpkgs.legacyPackages.${system}; [
      #       nixfmt
      #       nil
      #     ];
      #   };
      # });
    };
}
