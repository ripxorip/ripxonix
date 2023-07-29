{ lib, pkgs, ... }:
{
  imports = [
    ../../pkgs/ripxonix-installer
    ../_mixins/services/tailscale.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
