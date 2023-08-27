{ hostname, pkgs, username, ... }: {
  services.flatpak = {
    enable = true;
  };
  environment.systemPackages = [ pkgs.flatpak-builder ];
}
