# My main homelab
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../_mixins/services/tailscale.nix
    ../_mixins/services/syncthing.nix
    ../_mixins/services/jellyfin.nix
    ../_mixins/services/pipewire.nix
    ../_mixins/services/sanoid.nix
    ../_mixins/services/ripxobot.nix
    ../_mixins/streaming
    ../_mixins/virt
  ];

  # Overrides for virt (specifically windows 11 support)
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
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

  # Syncthing
  services.syncthing.guiAddress = "0.0.0.0:8384";

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

  # Override the time of day to run the housekeeper
  systemd.timers.ripxobot-housekeeper.timerConfig.OnCalendar = lib.mkForce "*-*-* 01:00:00";
  # Enable once the housekeeper is stable
  systemd.timers.ripxobot-housekeeper.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;

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

  fileSystems."/mnt/nvr" =
    {
      device = "/dev/disk/by-uuid/fb93ec8f-2c8c-4504-aad8-7d0e9123e34c";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7cd59f45-ac9f-4c8f-87df-fbaa809bc1d3"; }];

  # Working nfs example below
  # Just need to make sure that the zfs dataset exists
  # Mount using e.g : sudo mount -t nfs -o vers=4 10.0.0.175:/export /mnt

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /mnt/nvme_zfsdata/byte_bunker 100.64.0.0/10(rw,nohide,no_root_squash,insecure,no_subtree_check)
    /mnt/zfsdata/storage 100.64.0.0/10(rw,nohide,no_root_squash,insecure,no_subtree_check)
    /mnt/zfsdata/storage/media 100.64.0.0/10(rw,nohide,no_root_squash,insecure,no_subtree_check)
    /mnt/kodi 10.0.0.0/24(rw,nohide,no_root_squash,insecure,no_subtree_check)
  '';

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
        "path" = "/mnt/nvme_zfsdata/fast_storage/smb_share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.useDHCP = lib.mkForce false;
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.1" ];

  networking.interfaces.enp7s0 = {
    ipv4.addresses = [{
      "address" = "10.0.0.175";
      "prefixLength" = 24;
    }];
  };

  networking.bridges.br0.interfaces = [ "enp1s0f0" ];
  networking.interfaces.br0 = {
    ipv4.addresses = [{
      "address" = "10.0.0.112";
      "prefixLength" = 24;
    }];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
