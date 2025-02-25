{ pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];
  
  # Auto upgrade nix package and the daemon service.
  nix.enable = false;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  networking.hostName = "arcadia";
  networking.computerName = "arcadia";

  users.users.arcadia = {
    name = "arcadia";
    home = "/Users/arcadia";
  };

  home-manager = {
    useGlobalPkgs = true;
    users.arcadia = {
      home = {
        stateVersion = "25.05";
      };
      programs.home-manager.enable = true;
    };
    backupFileExtension = "backup";
  };
}