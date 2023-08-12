# Main workstation
{ config, lib, pkgs, ... }:
{
  imports = [
    ../_mixins/services/tailscale.nix
    ../_mixins/services/syncthing.nix
    ../_mixins/services/flatpak.nix
    ../_mixins/services/pipewire.nix
    ../_mixins/virt
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

    kernelModules = [ "kvm-amd" ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      timeout = 10;
    };

    kernelParams = [ "amd_iommu=on" "vfio-pci.ids=10de:1f07,10de:10f9,10de:1ada,10de:1adb" ];

    initrd = {
      kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"
        "zfs"
      ];

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
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/DBC6-6042";
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
    [{ device = "/dev/disk/by-uuid/ea121913-0867-416d-89ea-0243206ce592"; }];

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
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
