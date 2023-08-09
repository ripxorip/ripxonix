{ lib, modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (import ./disks.nix { })
    # ../_mixins/services/ripxobot.nix
  ];

  # For playing with zfs
  # boot.supportedFilesystems = [ "zfs" ];
  # boot.zfs.forceImportRoot = false;
  # boot.zfs.devNodes = "/dev/disk/by-partuuid";
  # boot.zfs.extraPools = [ "zfsdata" ];
  # networking.hostId = "9aa35b9a";

  # Override the time of day to run the housekeeper
  # systemd.timers.ripxobot-housekeeper.timerConfig.OnCalendar = lib.mkForce "*-*-* 01:00:00";
  # Enable once the housekeeper is stable
  # systemd.timers.ripxobot-housekeeper.enable = false;

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
