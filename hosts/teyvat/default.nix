{ config, pkgs, ... }:
{

  imports = [
    ./hardware.nix

    ../../hosts/common

    ../../hosts/common/optional/bluetooth.nix
    ../../hosts/common/optional/gpg.nix
    ../../hosts/common/optional/surfshark.nix

    ../../modules/qmk.nix
    ../../modules/gaming.nix
  ];

  neo.hostSpec = {
    hostName = "teyvat";
    isWireless = true;
    impermanence = {
      isEnabled = true;
      passwordPath = "/persist/passwords/v";
    };
  };
  
  neo.gaming.steam.enable = true;

  neo.qmk.enable = true;

  system.stateVersion = "24.11";
}
