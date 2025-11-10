{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
      postDeviceCommands = pkgs.lib.mkBefore ''
        mkdir -p /mnt
        mount /dev/sdb3 /mnt

        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/broot /mnt/root

        umount /mnt
      '';
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "btrfs" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/08c5a66a-b13a-465b-8c79-fd02a439ef5f";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "relatime"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/08c5a66a-b13a-465b-8c79-fd02a439ef5f";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "compress=zstd"
      "relatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/08c5a66a-b13a-465b-8c79-fd02a439ef5f";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "relatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/08c5a66a-b13a-465b-8c79-fd02a439ef5f";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "relatime"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/08c5a66a-b13a-465b-8c79-fd02a439ef5f";
    fsType = "btrfs";
    options = [
      "subvol=persist"
      "compress=zstd"
      "relatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1574-6E5D";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/51263b09-735c-4058-8d45-60860c8e9d3e"; }
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
