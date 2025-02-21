# Dell XPS 9520
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

  hardware.bluetooth.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "usbmon" "vhci-hcd" "usbip_host" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8814au
  ];

  # See https://github.com/Mic92/envfs (for scripts to get access to /bin/bash etc.)
  services.envfs.enable = true;
  services.printing.enable = true;
  services.fwupd.enable = true;

  # Hdd sleep udev rule:
  services.udev.extraRules = ''
    SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
  '';

  systemd.services.usbipd = {
    description = "USB/IP daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.linuxPackages.usbip}/bin/usbipd";
      Restart = "always";
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/2415ea65-b291-4dce-bbad-c67855a1b24c";
      fsType = "btrfs";
      options = [ "subvol=@nix_root" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/7C3E-7058";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/2415ea65-b291-4dce-bbad-c67855a1b24c";
      fsType = "btrfs";
      options = [ "subvol=@nix_home" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/2415ea65-b291-4dce-bbad-c67855a1b24c";
      fsType = "btrfs";
      options = [ "subvol=@nix_nix" "noatime" "compress=lzo" "ssd" "space_cache=v2" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/3a46a5ce-4a75-4d43-b83b-91950afd8784"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # In order for VSCode remote to work
  programs.nix-ld.enable = true;
  programs.talon.enable = true;
  programs.adb.enable = true;

  # PXE Boot example for the Pi
  #  services.dnsmasq.enable = true;
  #  services.dnsmasq.resolveLocalQueries = false;
  #
  #  services.dnsmasq.settings = {
  #    interface = "enp0s13f0u3"; # Specify the interface
  #    bind-interfaces = true; # Bind even if the interface is down
  #    enable-tftp = true; # Enable TFTP
  #    tftp-root = "/pxe/tftp"; # TFTP directory
  #    dhcp-range = "192.168.144.100,192.168.144.120,12h";
  #    dhcp-boot = "bootcode.bin"; # PXE boot file
  #    pxe-service="0,\"Raspberry Pi Boot\"";
  #  };
  #
  #  networking.interfaces.enp0s13f0u3 = {
  #    useDHCP = false; # No DHCP for this interface
  #    ipv4.addresses = [{
  #      address = "192.168.144.1";
  #      prefixLength = 24;
  #    }];
  #  };
  #
  #  services.nfs.server.enable = true;
  #  services.nfs.server.exports = ''
  #    /pxe/rootfs *(rw,sync,no_subtree_check,no_root_squash)
  #    /pxe/tftp *(rw,sync,no_subtree_check,no_root_squash)
  #  '';

  hardware.spacenavd.enable = true;

  environment.systemPackages = with pkgs; [
    freecad-wayland
    obs-studio
    remmina
    kicad
    prusa-slicer
    wireshark
    reaper
    teams-for-linux
    yabridge
    yabridgectl
    wineWowPackages.unstable
    winetricks
    tuxguitar
    moonlight-qt
    linuxPackages.usbip
    wakeonlan
    distrobox
    samba
    (pkgs.python3.withPackages (ps: with ps; [ pyserial python-lsp-server ]))
  ];
}
