{
  config,
  lib,
  pkgs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "Europe/Berlin";

  security.sudo.extraConfig = "Defaults lecture=\"never\"";

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  # };

  users.users.tori = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPasswordFile = "/persist/passwords/tori";
    shell = pkgs.zsh;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    zsh.enable = true;
    firefox.enable = true;
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

    # Networking applications
    curl
    wget
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
