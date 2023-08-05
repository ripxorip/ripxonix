# Linode VPS
{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../_mixins/services/tailscale.nix
    ../_mixins/services/ripxobot.nix
    ../_mixins/virt
  ];

  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_scsi" "ahci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  boot.loader.grub.forceInstall = true;

  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "ef6b9cc7";
  boot.zfs.extraPools = [ "zfsdata" ];

  # In order for VSCode remote to work
  programs.nix-ld.enable = true;

systemd.timers.ripxobot-housekeeper = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistant=true;
      Unit = "ripxobot-housekeeper.service";
    };
  };

  # This needs my full environment, hmm, user service instead? Needs som more investigation!
  systemd.services.ripxobot-housekeeper = {
    path = ["/run/wrappers/" pkgs.coreutils pkgs.gawk pkgs.syncoid pkgs.tailscale pkgs.matrix-sh];
    unitConfig = {
      Description = "The ripxobot housekeeper";
      Requires = [ "local-fs.targetz" ];
      After = [ "local-fs.target" ];
    };
    serviceConfig = {
      User = "ripxorip";
      Type = "oneshot";
      ExecStart = "${pkgs.python3}/bin/python /home/ripxorip/dev/ripxobot/ripxobot.py";
      WorkingDirectory = "/home/ripxorip/dev/ripxobot/";
    };
  };

  fileSystems."/" =
    {
      device = "/dev/sda";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/sdb"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault
    true;
  # networking.interfaces.enp0s5.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault
    "x86_64-linux";

}
