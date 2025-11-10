{
  config,
  lib,
  pkgs,
  nixpkgs,
  templates,
  ...
}:

let
  cfg = config.neo.hostSpec;
in
{

  imports = [
    ./host-spec.nix
    ./unfree.nix
  ];

  networking = {
    hostName = cfg.hostName;
    networkmanager.enable = cfg.isWireless;
  };

  nix = {
    registry.p.flake = nixpkgs;
    registry.templates.flake = templates;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  users.users.v = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ]
    ++ (if cfg.isWireless then [ "networkmanager" ] else [ ]);

    hashedPasswordFile = lib.mkIf cfg.impermanence.isEnabled cfg.impermanence.passwordPath;

    shell = pkgs.zsh;
  };

  # Basic services shared across systems
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    nixseparatedebuginfod2.enable = true;
  };

  # Basic programs shared across systems
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    zsh.enable = true;
    git.enable = true;
  };

  # Basic packages shared across systems
  environment.systemPackages = with pkgs; [
    # Command line utils
    htop
    iftop
    strace
    ltrace
    brightnessctl
    typos
    nixfmt-rfc-style
    tree

    # Replacements of modern Unix commands
    uutils-coreutils
    bat
    eza
    ripgrep
    fd
    fzf

    # Networking applications
    curl
    wget

    zip
    unzip

    nix-output-monitor
    nh
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  time.timeZone = "Europe/Berlin";
  security.sudo.extraConfig = "Defaults lecture=\"never\"";
}
