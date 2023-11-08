# Linode VPS
{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];

  users.groups.www-data.members = [ "ripxorip" "www-data" ];
  users.groups.www-data.gid = 33;

  users.users.www-data =
    {
      group = "www-data";
      isSystemUser = true;
      uid = 33;
    };

  services.caddy = {
    enable = true;
    virtualHosts."migic.com".extraConfig = ''
      reverse_proxy localhost:3123
    '';
  };

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

  fileSystems."/" =
    {
      device = "/dev/sda";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/sdb"; }];

  networking.usePredictableInterfaceNames = false;
  # TODO Re-enable when I figure out networking again
  # networking.interfaces.eth0.useDHCP = true;

  #
  # This section below is just to disable ipv6 on Linode
  # In the future this will be removed so that ipv6 can be
  # enabled again but for now during development it will be disabled
  #
  networking.enableIPv6 = false;
  boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;

  systemd.network.enable = true;

  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "eth0";

    networkConfig = {
      DHCP = "no";

      Address = "172.232.146.252/24";
      Gateway = "172.232.146.1";

      Domains = "ip.linodeusercontent.com";
      DNS = [
        "178.79.182.5"
        "176.58.107.5"
        "176.58.116.5"
        "176.58.121.5"
        "151.236.220.5"
        "212.71.252.5"
        "212.71.253.5"
        "109.74.192.20"
        "109.74.193.20"
        "109.74.194.20"
      ];
    };
  };
  # Down to here

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

}
