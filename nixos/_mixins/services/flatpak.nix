{ hostname, pkgs, username, ... }: {
  services.flatpak = {
    enable = true;
  };
}
