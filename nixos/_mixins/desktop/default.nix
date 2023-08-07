{ desktop, lib, pkgs, ... }: {
  imports = [
  ]
  ++ lib.optional (builtins.pathExists (./. + "/${desktop}.nix")) ./${desktop}.nix;

  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  services.xserver.layout = "us";
  services.xserver.xkbVariant = "colemak_dh";
  services.xserver.xkbOptions = "eurosign:e,caps:ctrl_modifier";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    vlc
    kitty
    logseq
    spotify
  ];

}
