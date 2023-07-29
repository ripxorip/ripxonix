{ lib, pkgs, ... }:
{
  imports = [
    ../_mixins/services/tailscale.nix
  ];

environment = {
    systemPackages = with pkgs; [
      ripxonix-installer
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
