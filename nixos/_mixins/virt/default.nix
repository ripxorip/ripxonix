{ desktop, lib, pkgs, ... }: {
  imports = [ ] ++ lib.optional (builtins.isString desktop) ./desktop.nix;

  #https://nixos.wiki/wiki/Podman
  environment.systemPackages = with pkgs; [
  ];

  virtualisation = {
    docker = {
      enable = true;
      # FIXME Workaround until docker is updated
      # Will need to be removed in the near future
      package = pkgs.docker.override {
        buildGoPackage = pkgs.buildGo118Package;
      };
    };
    libvirtd = {
      enable = true;
    };
  };
}
