{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations = {
      simulation = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/simulation/configuration.nix
          inputs.home-manager.nixosModules.default
          ./nixosModules
          # ./homeModules
        ];
      };

      evacuated = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/evacuated/configuration.nix
          inputs.home-manager.nixosModules.default
          ./nixosModules
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "23.11";
            wsl.enable = true;
          }
          # ./homeModules
        ];
      };

    };
  };
}
