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
  boot.kernelModules = [ "kvm-intel" "usbmon" ];
  boot.extraModulePackages = [ ];

  # See https://github.com/Mic92/envfs (for scripts to get access to /bin/bash etc.)
  services.envfs.enable = true;

  # Hdd sleep udev rule:
  services.udev.extraRules = ''
    SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
  '';

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

  environment.systemPackages = with pkgs; [
    gomuks
    obs-studio
    remmina
    kicad
    prusa-slicer
    wireshark
    reaper
    (pkgs.python3.withPackages (ps: with ps; [ pyserial python-lsp-server ]))
  ];
}
