{ lib, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "teyvat";
    networkmanager.enable = true;
  };
}
