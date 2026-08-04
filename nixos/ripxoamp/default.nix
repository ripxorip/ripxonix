# The amp — Beelink SER3 (Ryzen 3 3200U, Vega 3, 16 GB) inside a tube guitar
# amp cabinet. The software it runs lives in ~/dev/ultimate_amp_fw; this file
# is only the machine.
#
# This is *bench mode* (ultimate_amp_fw docs/architecture.md §8): Plasma,
# read-write root, network up, Sunshine on HDMI-2. Bench mode is permanent —
# perform mode arrives later beside it and Plasma stays here forever.
#
# The one thing bench mode may not differ from perform mode on is the audio
# path, which is why PipeWire is off below despite the desktop.
{ config, lib, pkgs, ... }:
{
  imports = [
    ../_mixins/services/tailscale.nix
    (import ./disks.nix { })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # The ESP is shared with the eventual perform-mode ramdisk; don't let bench
  # generations eat it.
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  # Early KMS. §13 rejects deferring amdgpu for boot speed: without it you're
  # on simpledrm with no modesetting and no real page flipping.
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];

  # A USB interface that gets autosuspended mid-set is an xrun. §13, item 4.
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # §13, item 1: the top xrun source on a 15 W mobile part. Also the only way
  # bench measurements mean anything.
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # No sound server, in any mode — Reaper owns the 2i2 directly over ALSA.
  # Plasma sets pipewire.enable with mkDefault, so this wins; all that is lost
  # is the volume applet, and there is no system audio worth wanting here.
  services.pipewire.enable = false;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Appliance: no keyboard in normal use, so it comes up in the desktop by
  # itself. HDMI-1 is the panel LCD, HDMI-2 is Reaper — that topology is a
  # mode-unit concern (§8) and isn't declared yet.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ripxorip";
  services.displayManager.defaultSession = "plasma";
  services.displayManager.sddm.wayland.enable = true;

  # §9: the editing surface comes to you while the audio stays at the amp.
  # Bench-only by construction — perform mode never starts it. Reachable over
  # Tailscale; the pairing UI is not for the open network.
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # The writable state partition, mounted from day one so perform mode is a
  # boot-method change rather than a data migration. `amp-reaper` from the
  # ultimate_amp_fw flake reads AMP_REAPER_STATE, so `nix run .#reaper` on this
  # box lands in the right place with nothing to remember.
  systemd.tmpfiles.rules = [
    "d /amp        0755 ripxorip users -"
    "d /amp/reaper 0755 ripxorip users -"
    "d /amp/wine   0755 ripxorip users -"
    "d /amp/models 0755 ripxorip users -"
  ];
  environment.variables.AMP_REAPER_STATE = "/amp/reaper";
  environment.variables.WINEPREFIX = "/amp/wine/default";

  environment.systemPackages = with pkgs; [
    alsa-utils
    # vainfo — M0 wants hardware H.264/HEVC encode confirmed on Vega 3 before
    # Sunshine is trusted.
    libva-utils
  ];

  # In order for VSCode remote to work
  programs.nix-ld.enable = true;

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
