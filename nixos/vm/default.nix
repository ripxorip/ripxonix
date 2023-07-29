{ lib, modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (import ./disks.nix { })
  ];

  swapDevices = [{
    device = "/swap";
    size = 1024;
  }];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ohci_pci" "ehci_pci" "virtio_pci" "ahci" "usbhid" "sr_mod" "virtio_blk" ];
    kernelPackages = pkgs.linuxPackages_latest;

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
