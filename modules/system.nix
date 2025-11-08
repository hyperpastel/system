{
  config,
  lib,
  pkgs,
  nixpkgs,
  templates,
  nixseparatedebuginfod,
  ...
}:

let
  settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
in
{
  nix = {
    registry.p.flake = nixpkgs;
    registry.templates.flake = templates;

    inherit settings;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "Europe/Berlin";

  security.sudo.extraConfig = "Defaults lecture=\"never\"";

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  # };

  users.users.v = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPasswordFile = "/persist/passwords/v";
    shell = pkgs.zsh;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  services.nixseparatedebuginfod2.enable = true;

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    zsh.enable = true;

    git.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # Command line utils
    htop
    iftop
    strace
    ltrace
    brightnessctl
    typos
    nixfmt-rfc-style

    # Replacements of modern Unix commands
    uutils-coreutils
    bat
    eza
    ripgrep
    fd

    # Networking applications
    curl
    wget

    zip
    unzip
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    # nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka-term-slab
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
