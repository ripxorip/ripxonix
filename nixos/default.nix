{ config, desktop, hostname, inputs, lib, modulesPath, outputs, pkgs, stateVersion, username, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./${hostname}
    ./_mixins/users/${username}
  ] ++ lib.optional (builtins.isString desktop) ./_mixins/desktop;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

  environment = {
    defaultPackages = with pkgs; lib.mkForce [
      home-manager
      vim
      rsync
    ];
    systemPackages = with pkgs; [
      pciutils
      psmisc
      unzip
      usbutils
      python3
    ];
    variables = {
      EDITOR = "vim";
      SYSTEMD_EDITOR = "vim";
      VISUAL = "vim";
    };
  };


  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Iosevka" ]; })
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Accept the joypixels license
      joypixels.acceptLicense = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise.automatic = true;
    package = pkgs.unstable.nix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
  networking.firewall.enable = false;

  system.stateVersion = stateVersion;
}
