{ pkgs, ... }: {
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    # unstable.quickemu
    # for running X11 apps in distrobox
    # xorg.xhost
  ];
}
