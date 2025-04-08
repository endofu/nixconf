{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, darwin, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # NixOS configuration helpers
      nixosSystem = system: hostname: modules:
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
      darwinSystem = system: hostname: modules:
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
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
          };
        };
    in
    {
      # NixOS configurations
      nixosConfigurations = {
        laptop = nixosSystem "x86_64-linux" "laptop" [];
        server = nixosSystem "x86_64-linux" "server" [];
      };

      # Darwin configurations
      darwinConfigurations = {
        macbook = darwinSystem "aarch64-darwin" "macbook" [];
        mac-mini = darwinSystem "aarch64-darwin" "mac-mini" [];
      };

      # Custom packages
      packages = forAllSystems (system: import ./pkgs { 
        pkgs = nixpkgs.legacyPackages.${system};
      });
      
      # Development shell
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nixfmt
            nil
          ];
        };
      });
    };
}