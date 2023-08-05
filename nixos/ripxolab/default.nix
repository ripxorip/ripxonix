# My main homelab
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../_mixins/services/tailscale.nix
    ../_mixins/services/caddy.nix
    ../_mixins/services/syncthing.nix
    ../_mixins/services/jellyfin.nix
    ../_mixins/services/flatpak.nix
    ../_mixins/services/sanoid.nix
    ../_mixins/services/ripxobot.nix
    ../_mixins/virt
  ];

  # Auto login
  services.xserver.displayManager.autoLogin.user = "ripxorip";
  services.xserver.displayManager.autoLogin.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "c0c6d51d";
  boot.zfs.extraPools = [ "zfsdata" "nvme_zfsdata" ];

  # Hdd sleep udev rule:
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTRS{queue/rotational}=="1", RUN+="${pkgs.hdparm}/bin/hdparm -S 120 /dev/%k"
  '';

  # In order for VSCode remote to work
  programs.nix-ld.enable = true;

  # FIXME Workaround until docker is updated
  # Will need to be removed in the near future
  virtualisation.docker.package = pkgs.docker.override { buildGoPackage = pkgs.buildGo118Package; };

  # Override the time of day to run the housekeeper
  systemd.timers.ripxobot-housekeeper.timerConfig.OnCalendar = lib.mkForce "*-*-* 01:00:00";

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/056d7ff2-30ae-4ceb-a994-bfebaed4f850";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/1FAE-1742";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7cd59f45-ac9f-4c8f-87df-fbaa809bc1d3"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
