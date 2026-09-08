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

  # Set Git commit hash for darwin-version
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility
  system.stateVersion = 6;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Networking configuration
  networking.hostName = "samos";
  networking.computerName = "samos";

  # User configuration
  users.users.samos = {
    name = "samos";
    home = "/Users/samos";
  };

  system.primaryUser = "samos";

  # Enable modules
  modules = {
    basics.enable = true;
    claude-code.enable = true;
    ffmpeg.enable = false;
    fonts.enable = true;
    tailscale.enable = true;
    resilio.enable = true;
    llm.enable = true;
    codex.enable = true;
    codex-cli.enable = true;
    opencode.enable = true;
    gemini.enable = true;
    antigravity.cli.enable = true;
    herdr.enable = true;
    linear.enable = true;
    mosquitto = {
      enable = true;
      mqttui.enable = true;
    };

    karabiner.enable = true;
    darwin-basics.enable = true;
    homebrew.enable = true;
    macos.enable = true;
    macos-apps.enable = true;
    podman.enable = true;
    ghostty.enable = true;
    infra.enable = true;
  };

  home-manager.users = {
    samos = import ../../../home/users/samos;
  };

  sops.defaultSopsFile = ./../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/Users/samos/.config/sops/age/keys.txt";

  sops.secrets.gemini_api_key = {
    owner = "samos";
  };
  sops.secrets.anthropic_api_key = {
    owner = "samos";
  };
  sops.secrets.github_token = {
    owner = "samos";
  };
  programs.zsh.shellInit = ''
    export GOOGLE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    export GEMINI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    export GOOGLE_GENERATIVE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    export ANTHROPIC_API_KEY="$(cat /run/secrets/anthropic_api_key)"
    export GITHUB_TOKEN="$(cat /run/secrets/github_token)"
  '';
}
