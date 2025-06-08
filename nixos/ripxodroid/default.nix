# My secondary homelab
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../_mixins/services/tailscale.nix
    ../_mixins/virt
    (import ./disks.nix { })
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

  # In order for VSCode remote to work
  programs.nix-ld.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"  ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-intel" "usbmon" "vhci-hcd" "usbip_host" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ripxorip";
  services.displayManager.defaultSession = "plasma";
  services.displayManager.sddm.wayland.enable = true;

  systemd.services.usbipd = {
    description = "USB/IP daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.linuxPackages.usbip}/bin/usbipd";
      Restart = "always";
    };
  };

  environment.systemPackages = with pkgs; [
    moonlight-qt
    linuxPackages.usbip
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
  };

  fileSystems."/mnt/kodi" = {
    device = "10.0.0.175:/mnt/kodi";
    fsType = "nfs";
  };

  # FIXME Setup properly for the odroid
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
