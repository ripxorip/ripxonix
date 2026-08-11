# The amp — Beelink SER3 (Ryzen 3 3200U, Vega 3, 16 GB) inside a tube guitar
# amp cabinet. The software it runs lives in ~/dev/ultimate_amp_fw; this file
# is only the machine.
#
# This is *bench mode* (ultimate_amp_fw docs/architecture.md §8): Plasma,
# read-write root, network up, Sunshine on HDMI-1. Bench mode is permanent —
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
  # uinput: Sunshine's virtual keyboard/mouse. See the nixpkgs#455737 note below.
  boot.kernelModules = [ "kvm-amd" "uinput" ];

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

  # The amp's audio thread runs SCHED_FIFO, and this is what lets it.
  #
  # rtkit above is not enough on its own and never was: it only raises a
  # process that asks it to, over D-Bus. The engine's old JUCE audio backend
  # never asked — juce_Threads_linux.cpp has no scheduler support on Linux at
  # all — so the audio thread ran SCHED_OTHER at nice 0, in the same class as
  # the panel repaint and the X server, on a two-core 15 W part. That is what a
  # neural amp model at 64 frames was losing its deadline to, and a lost
  # deadline is heard as modulation rather than as a click. ultimate_amp_fw's
  # engine/src/core/Audio.cpp now asks directly, which needs the rlimit rather
  # than the daemon.
  #
  # `-` sets both the soft and hard limit, so the grant needs no login shell
  # to raise it. 95 rather than 99: leave the top of the range to the kernel's
  # own threads, since a runaway at 99 on two cores is an unrecoverable box.
  # memlock is here for the day the engine calls mlockall; nothing does yet.
  security.pam.loginLimits = [
    { domain = "@audio"; type = "-"; item = "rtprio";  value = "95"; }
    { domain = "@audio"; type = "-"; item = "memlock"; value = "unlimited"; }
  ];

  # Appliance: no keyboard in normal use, so it comes up in the desktop by
  # itself. HDMI-2 is the panel LCD (1024x600), HDMI-1 is Reaper — verified on
  # the machine with kscreen-doctor; §8 had these the other way round until the
  # amp existed and could be asked. That topology is a mode-unit concern and
  # isn't declared yet.
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

  # Workaround for nixpkgs#455737: the sunshine package ships no udev rules, so
  # services.sunshine's own services.udev.packages entry installs nothing and
  # /dev/uinput stays root:root 0600. The stream still renders, but every
  # virtual input device fails with "Permission denied" and the remote keyboard
  # and mouse are silently dead — which is the whole point of §9. Joining the
  # input group alone does nothing until a rule puts the node in that group.
  # uaccess covers the autologin session, the group covers the case where no
  # seat is active. Drop this once the package carries its own rules.
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", MODE="0660", GROUP="input"
  '';
  # input: Sunshine's uinput node, per the rule above.
  # audio: the rtprio grant in security.pam.loginLimits — the limit is written
  # against @audio, so membership is what actually delivers it.
  users.users.ripxorip.extraGroups = [ "input" "audio" ];

  # The panel's SHUT DOWN menu item. ampd is an unprivileged Tier 1 daemon, so
  # the grant has to live here — ultimate_amp_fw owns the software, this repo
  # owns the box, and "may this user power the machine off" is a box question.
  #
  # Two action ids, and the second is the one that actually fires. logind only
  # consults `power-off` when the caller's is the sole session; with more than
  # one it checks `power-off-multiple-sessions` instead. This box always has
  # several (the autologin seat, plus any ssh), so a rule granting only the
  # first is refused in a way that looks identical to no rule at all.
  #
  # Deliberately not sudo: no NOPASSWD entry, no setuid binary in an
  # appliance's path, and this grants exactly one capability to one user.
  # Verify without losing the session:  systemctl --dry-run poweroff
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.user == "ripxorip" &&
          (action.id == "org.freedesktop.login1.power-off" ||
           action.id == "org.freedesktop.login1.power-off-multiple-sessions")) {
        return polkit.Result.YES;
      }
    });
  '';

  # The RP2040's udev rules -- /dev/ttyAmpIO, unprivileged access in BOOTSEL
  # and running states, and ModemManager kept away from the CDC port. The
  # engine falls back to /dev/ttyACM0 without this, which works right up until
  # something else enumerates first.
  hardware.ultimateAmpIo.enable = true;

  # The amp itself, as a session service. A *user* unit, because the engine is
  # an X11 application and needs the session's display and xauth cookie; see
  # the module in ultimate_amp_fw's flake for why that is the whole design.
  #
  # Which also means the bench workflow is systemctl:
  #
  #   systemctl --user stop amp     # then run the ninja build by hand
  #   systemctl --user start amp
  #   journalctl --user -u amp -f
  services.ultimateAmp = {
    enable = true;
    # Defaults are /amp/models and /amp/presets; named here because the
    # tmpfiles rules below have to agree with them.
    modelDir = "/amp/models";
    presetDir = "/amp/presets";
    # In the journal: in/out peak and the xrun count, once a second. It is what
    # tells a silent chain from a starved one, and both look identical from
    # outside.
    extraArgs = [ "--meter" ];
  };

  # The writable state partition, mounted from day one so perform mode is a
  # boot-method change rather than a data migration. `amp-reaper` from the
  # ultimate_amp_fw flake reads AMP_REAPER_STATE, so `nix run .#reaper` on this
  # box lands in the right place with nothing to remember.
  #
  # presets/ is the one directory the amp writes to: SAVE puts a file there,
  # which is exactly why it cannot live in a store path or in a checkout that
  # a read-only perform-mode root would freeze.
  systemd.tmpfiles.rules = [
    "d /amp         0755 ripxorip users -"
    "d /amp/reaper  0755 ripxorip users -"
    "d /amp/wine    0755 ripxorip users -"
    "d /amp/models  0755 ripxorip users -"
    "d /amp/presets 0755 ripxorip users -"
  ];
  environment.variables.AMP_REAPER_STATE = "/amp/reaper";
  environment.variables.WINEPREFIX = "/amp/wine/default";

  # For a shell on the box: `nix run .#engine` and the dev-shell build both
  # read these, so running the engine by hand needs no arguments either.
  environment.variables.AMP_MODEL_DIR = "/amp/models";
  environment.variables.AMP_PRESET_DIR = "/amp/presets";

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
