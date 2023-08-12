# Main workstation # Currently in a VM to get the hang of things
{ config, lib, pkgs, ... }:
{
  imports = [
    # Start as a VM
    (modulesPath + "/profiles/qemu-guest.nix")
    ../_mixins/services/tailscale.nix
    ../_mixins/services/syncthing.nix
    ../_mixins/services/flatpak.nix
    ../_mixins/services/pipewire.nix
    #../_mixins/virt
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ohci_pci" "ehci_pci" "virtio_pci" "ahci" "usbhid" "sr_mod" "virtio_blk" ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      timeout = 10;
    };

    initrd = {
      kernelModules = [ "zfs" ];

      postDeviceCommands = ''
        zpool import -lf rootp
      '';
    };
    supportedFilesystems = [ "zfs" ];

    zfs = {
      devNodes = "/dev/disk/by-partlabel";
      forceImportRoot = true;
    };
  };

  networking.hostId = "1ba30e4b";

  # See https://github.com/Mic92/envfs (for scripts to get access to /bin/bash etc.)
  services.envfs.enable = true;

  fileSystems."/" =
    {
      device = "rootp/root";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/C3BD-7E85";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "rootp/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "rootp/nix";
      fsType = "zfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/a054b28a-73b3-4f16-a70a-9e60d4cd05f1"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    #kicad
    (pkgs.python3.withPackages (ps: with ps; [ pyserial python-lsp-server ]))
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
