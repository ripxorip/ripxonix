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
  services.displayManager.autoLogin.user = "ripxorip";
  services.displayManager.autoLogin.enable = true;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  hardware.bluetooth.enable = true;
  hardware.rtl-sdr.enable = true;

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

    kernelModules = [ "kvm-amd" "usbip_core" "vhci_hcd" ];

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
  fileSystems."/mnt/smb_share" =
    {
      device = "rootp/smb_share";
      fsType = "zfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/ea121913-0867-416d-89ea-0243206ce592"; }];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "ripxonix";
        "netbios name" = "ripxonix";
        "guest account" = "ripxorip";
        "map to guest" = "bad user";
        "security" = "user";
      };
      "public" = {
        "path" = "/mnt/smb_share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="04da", ATTR{idProduct}=="10fa", MODE="0666", GROUP="adbusers"
  '';

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  fileSystems."/mnt/nvr" =
    {
      device = "/dev/disk/by-uuid/fb93ec8f-2c8c-4504-aad8-7d0e9123e34c";
      fsType = "ext4";
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
  networking.interfaces.enp7s0.wakeOnLan.enable = true;

  networking.bridges.br0.interfaces = [ "enp7s0" ];
  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [{
      "address" = "10.0.0.230";
      "prefixLength" = 24;
    }];
  };
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" ];

  programs.talon.enable = true;
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    kicad
    (pkgs.python3.withPackages (ps: with ps; [ pyserial python-lsp-server ]))
    barrier
    prusa-slicer
    podman-compose
    wine
    reaper
    yabridge
    yabridgectl
    linuxPackages.usbip
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
