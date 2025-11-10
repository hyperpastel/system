{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ../../hosts/common

    ../../hosts/common/optional/bluetooth.nix
    ../../hosts/common/optional/gpg.nix
    ../../hosts/common/optional/surfshark.nix
    ../../hosts/common/optional/ssh.nix

    ../../modules/gaming.nix
  ];

  neo.hostSpec = {
    hostName = "darksea";
    isWireless = false;
    impermanence = {
      isEnabled = true;
      passwordPath = "/persist/passwords/v";
    };
  };

  neo.gaming = {
    steam.enable = true;
    clipping.enable = true;
    isNVIDIA = true;
    discord.enable = true;
  };

  system.stateVersion = "25.11";
}
