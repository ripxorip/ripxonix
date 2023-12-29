# Main workstation
{ config, lib, pkgs, ... }:
{
  imports = [
    ../_mixins/services/tailscale.nix
    ../_mixins/services/syncthing.nix
    ../_mixins/services/flatpak.nix
    ../_mixins/services/pipewire.nix
    ../_mixins/virt
    ../_mixins/streaming
  ];

  # I want to experiment using podman instead of docker for a while
  virtualisation = {
    docker = {
      enable = lib.mkForce false;
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    # I want to explore using a genuine Win11 box as station server,
    # since the ovmf full was the issue this might be able to set as
    # standard now?
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.enable = true;
        swtpm.enable = true;
      };
    };
  };

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

  # Auto login
  services.xserver.displayManager.autoLogin.user = "ripxorip";
  services.xserver.displayManager.autoLogin.enable = true;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  hardware.bluetooth.enable = true;

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

  fileSystems."/var/lib/libvirt/images" =
    {
      device = "rootp/libvirt_images";
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

  programs.talon.enable = true;

  environment.systemPackages = with pkgs; [
    kicad
    (pkgs.python3.withPackages (ps: with ps; [ pyserial python-lsp-server ]))
    barrier
    prusa-slicer
    podman-compose
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
