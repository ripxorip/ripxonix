{ lib, hostname, ... }: {
  imports = [ ]
    ++ lib.optional (builtins.pathExists (./. + "/hosts/${hostname}.nix")) ./hosts/${hostname}.nix;

  home = { };

  systemd.user.tmpfiles.rules = [ ];
}
