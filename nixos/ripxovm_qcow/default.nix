{ lib, modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

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
    };

  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
