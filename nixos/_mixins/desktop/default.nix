{ desktop, lib, pkgs, ... }: {
  imports = [
  ]
  ++ lib.optional (builtins.pathExists (./. + "/${desktop}.nix")) ./${desktop}.nix;

  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

}
