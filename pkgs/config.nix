{
  config = {
    # Allow unfree packages
    allowUnfree = true;
    
    # Allow packages with broken dependencies
    allowBroken = false;
    
    # Allow packages whose license couldn't be determined
    allowUnsupportedSystem = false;
    
    # Use the system provided OpenGL drivers
    hardware.opengl.setLdLibraryPath = true;
    
    # Set Firefox preferences
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = false;
    };
    
    # Accelerate builds by using binary cache
    nix = {
      binaryCaches = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      binaryCachePublicKeys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trustedUsers = [ "root" "@wheel" ];
    };
  };
}