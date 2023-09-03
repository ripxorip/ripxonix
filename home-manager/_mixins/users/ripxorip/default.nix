{ lib, hostname, ... }: {
  imports = [ ]
    ++ lib.optional (builtins.pathExists (./. + "/hosts/${hostname}.nix")) ./hosts/${hostname}.nix;

  home = { };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };

  systemd.user.tmpfiles.rules = [ ];
}
