{ lib, modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (import ./disks.nix { })
  ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.zfs.extraPools = [ "zfsdata" ];

  networking.hostId = "9aa35b9a";

  swapDevices = [{
    device = "/swap";
    size = 1024;
  }];

  # In order for VSCode remote to work
  programs.nix-ld.enable = true;

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ohci_pci" "ehci_pci" "virtio_pci" "ahci" "usbhid" "sr_mod" "virtio_blk" ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      timeout = 10;
    };

  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
