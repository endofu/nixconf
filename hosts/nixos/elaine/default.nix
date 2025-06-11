{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Hardware-specific configuration
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  nixpkgs.config.allowUnfree = true;

  # Include modules by enabling them
  modules = {
    basics.enable = true;
    code-agents.enable = true;

    desktop = {
      enable = true;
      windowManager = "kde";
    };
    fonts.enable = true;
    teamviewer.enable = true;
    llm.enable = true;

    server = {
      enable = true;
      sshd = {
        enable = true;
        permitRootLogin = "no";
        passwordAuthentication = false;
      };
      services = {
        enable = true;
        nginx = false;
        postgresql = false;
        docker = false;
      };
    };
    networking = {
      enable = true;
      enableWireless = true;
      enableVPN = false;
      firewall = {
        enable = true;
        allowedTCPPorts = [
          22
          80
          8080
          443
        ];
        allowedUDPPorts = [ 8001 ];
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Machine-specific configurations
  networking.hostName = "elaine";

  # Define users and their home-manager configurations
  users.users.elaine = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    #     openssh.authorizedKeys.keys = [
    #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJqr1ylpMV5g+CtuHd8jmjh4JB6Bt6EFMCJISYTLmFqM alice@example.com"
    #     ];
  };

  home-manager.users = {
    elaine = import ../../../home/users/elaine;
  };

  # System-specific packages
  environment.systemPackages = with pkgs; [
    # Server-specific packages
    cifs-utils
    autorandr
  ];

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  sops.defaultSopsFile = ./../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/elaine/.config/sops/age/keys.txt";

  sops.secrets.gemini_api_key = {
    owner = "elaine";
  };
  sops.secrets.anthropic_api_key = {
    owner = "elaine";
  };
  programs.bash.shellInit = ''
    export GOOGLE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    export ANTHROPIC_API_KEY="$(cat /run/secrets/anthropic_api_key)"
  '';
}
