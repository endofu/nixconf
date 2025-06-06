{
  ...
}:

{
  nix.enable = false;
  # System configuration
  nixpkgs.config.allowUnfree = true;

  # Set Git commit hash for darwin-version
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility
  system.stateVersion = 6;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Networking configuration
  networking.hostName = "arcadia";
  networking.computerName = "arcadia";

  # User configuration
  users.users.arcadia = {
    name = "arcadia";
    home = "/Users/arcadia";
  };

  system.primaryUser = "arcadia";

  # Enable modules
  modules = {
    # Common modules
    fonts.enable = true;

    # Keyboard customization
    karabiner.enable = true;

    darwin-basics.enable = true;
  };

  # Home Manager configuration
  home-manager.users.arcadia =
    { pkgs, ... }:
    {
      home.stateVersion = "24.11";
      programs.home-manager.enable = true;
    };
}
