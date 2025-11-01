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

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "v4l2loopback" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "usbmon" "vhci-hcd" "usbip_host" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8814au
    v4l2loopback
  ];

  # See https://github.com/Mic92/envfs (for scripts to get access to /bin/bash etc.)
  services.envfs.enable = true;
  services.printing.enable = true;
  services.fwupd.enable = true;

  # Hdd sleep udev rule:
  services.udev.extraRules = ''
    SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
  '';

## Some black magic to get a custom resolution with a custom EDID...
  boot = {
    kernelParams = [ 
      "video=DP-6:2560x1440@100" 
    ];
    # Create custom EDID file in the firmware directory
    extraModprobeConfig = ''
      options drm edid_firmware=DP-6:edid/2560x1440.bin
      options v4l2loopback devices=1 video_nr=10 card_label=PhilipBrioStream exclusive_caps=1
    '';
  };

  # Add the EDID file to the system
  hardware.firmware = [
    (pkgs.runCommand "edid-2560x1440" {} ''
      mkdir -p $out/lib/firmware/edid
      echo -ne '\x00\xff\xff\xff\xff\xff\xff\x00\x1e\x6d\x01\x00\x01\x01\x01\x01\x01\x1c\x01\x04\xb5\x3c\x22\x78\x9e\x3e\x31\xa7\x54\x4c\x99\x26\x0f\x50\x54\x21\x08\x00\x71\x40\x81\x80\x81\xc0\xa9\xc0\xd1\xc0\x81\x00\x01\x01\x01\x01\x4d\xd0\x00\xa0\xf0\x70\x3e\x80\x30\x20\x35\x00\x55\x50\x21\x00\x00\x1a\x00\x00\x00\xfd\x00\x18\x64\x1e\xa0\x3c\x01\x0a\x20\x20\x20\x20\x20\x20\x00\x00\x00\xfc\x00\x44\x55\x4d\x4d\x59\x20\x31\x34\x34\x30\x70\x0a\x20\x00\x00\x00\xff\x00\x53\x65\x72\x69\x61\x6c\x0a\x20\x20\x20\x20\x20\x20\x01\x8c' > $out/lib/firmware/edid/2560x1440.bin
    '')
  ];


  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };


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

  musnix.enable = true;

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
