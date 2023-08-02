{ lib, pkgs, ... }:
{
  imports = [ ];
  dconf.settings = { };

    packages = with pkgs; [
      x11vnc
    ];
}
