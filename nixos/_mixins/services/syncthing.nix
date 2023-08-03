{ hostname, pkgs, username, ... }: {
  services.syncthing = {
    enable = true;
    user = "${username}";
    dataDir = "/home/${username}/Documents"; # Default folder for new synced folders
    configDir = "/home/${username}/.config/syncthing";
  };
}
