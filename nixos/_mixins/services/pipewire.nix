{ desktop, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alsa-utils
    pulseaudio
    pulsemixer
    qpwgraph
  ] ++ lib.optionals (desktop != null) [
    pavucontrol
  ];
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    pulseaudio.enable = false;
  };
}
