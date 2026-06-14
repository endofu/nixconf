{
  inputs,
  ...
}:

{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  nix.enable = false;

  # System configuration
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

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
    basics.enable = true;
    claude-code.enable = true;
    opencode.enable = false;
    ffmpeg.enable = true;
    fonts.enable = true;
    tailscale.enable = true;
    teams.enable = true;
    resilio.enable = true;

    karabiner.enable = true;
    darwin-basics.enable = true;
    homebrew.enable = true;
    macos.enable = true;
    macos-apps.enable = true;
    podman.enable = true;
    blender.enable = true;
    ghostty.enable = true;
    gemini.enable = true;
    antigravity.cli.enable = true;
    mosquitto = {
      enable = false;
      mqttui.enable = true;
    };
  };

  home-manager.users = {
    arcadia = import ../../../home/users/arcadia;
  };

  sops.defaultSopsFile = ./../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/Users/arcadia/.config/sops/age/keys.txt";

  sops.secrets.gemini_api_key = {
    owner = "arcadia";
  };
  sops.secrets.anthropic_api_key = {
    owner = "arcadia";
  };
  sops.secrets.github_token = {
    owner = "arcadia";
  };
  programs.zsh.shellInit = ''
    export GOOGLE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    export GEMINI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    export GOOGLE_GENERATIVE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    export ANTHROPIC_API_KEY="$(cat /run/secrets/anthropic_api_key)"
    export GITHUB_TOKEN="$(cat /run/secrets/github_token)"
  '';
}
