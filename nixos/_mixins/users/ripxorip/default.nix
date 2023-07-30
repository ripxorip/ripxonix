{ config, desktop, lib, pkgs, ... }:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # Only include desktop components if one is supplied.
  imports = [ ] ++ lib.optional (builtins.isString desktop) ./desktop.nix;

  environment.systemPackages = [
    # pkgs.yadm # Terminal dot file manager
  ];

  users.users.ripxorip = {
    isNormalUser = true;
    initialPassword = "ripxonix";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPV/ktL05mbhMNHis8zdpYUk76GcnVWXFrxEc8Hvtxhq ripxorip"
    ];
    extraGroups = [
      "wheel"
    ] # Enable ‘sudo’ for the user.
    ++ ifExists [
      "docker"
      "podman"
      "libvirtd"
    ];
    packages = with pkgs; [
      firefox
      tree
    ];
    shell = pkgs.zsh;
  };
}
