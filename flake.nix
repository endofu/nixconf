{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      nixos-wsl,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        simulation = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/simulation/configuration.nix
            home-manager.nixosModules.default
            ./nixosModules
            {
              system.stateVersion = "24.05";
            }
            # ./homeModules
          ];
        };

        evacuated = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/evacuated/configuration.nix
            home-manager.nixosModules.default
            ./nixosModules
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "23.11";
              wsl.enable = true;
            }
            # ./homeModules
          ];
        };

        elaine = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/elaine/configuration.nix
            home-manager.nixosModules.default
            ./commonModules
            ./nixosModules
            # nixos-wsl.nixosModules.default
            # ./homeModules
          ];
        };
      };

      darwinConfigurations = {
        arcadia = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/arcadia/configuration.nix
            ./darwinModules

            home-manager.darwinModules.home-manager

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;

                # User owning the Homebrew prefix
                user = "arcadia";

                # Optional: Declarative tap management
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };

                # Optional: Enable fully-declarative tap management
                #
                # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                mutableTaps = false;
              };
            }
          ];
        };
      };
    };
}
