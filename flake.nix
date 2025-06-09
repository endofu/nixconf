{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-2405.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "darwin";
    };
    
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-2405,
      darwin,
      home-manager,
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
