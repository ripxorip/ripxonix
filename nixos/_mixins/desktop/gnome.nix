{ ... }: {
  imports = [
  ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # GNOME now ships gcr-ssh-agent and asserts that it is the only ssh agent on
  # the system. _mixins/services/openssh.nix turns on programs.ssh.startAgent
  # for every host, so keep that one and stand GNOME's down -- otherwise the
  # GNOME machines behave differently from the rest for no reason.
  services.gnome.gcr-ssh-agent.enable = false;
}
