{ hostname, pkgs, username, ... }: {
  services.jellyfin = {
    enable = true;
  };
}
