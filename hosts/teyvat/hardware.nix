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
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
      postDeviceCommands = pkgs.lib.mkBefore ''
        mkdir -p /mnt
        mount /dev/nvme0n1p3 /mnt

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
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "btrfs" ];

  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/92e565cf-4574-4226-be3b-e04ca16a53fc";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "relatime"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/92e565cf-4574-4226-be3b-e04ca16a53fc";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "compress=zstd"
      "relatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/92e565cf-4574-4226-be3b-e04ca16a53fc";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "relatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/92e565cf-4574-4226-be3b-e04ca16a53fc";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "relatime"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/92e565cf-4574-4226-be3b-e04ca16a53fc";
    fsType = "btrfs";
    options = [
      "subvol=persist"
      "compress=zstd"
      "relatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BDBC-1294";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/55e38172-f30a-41ef-a415-cbf6ee738fbe"; }
  ];

  environment.etc = {
    "machine-id".source = "/persist/etc/machine-id";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
