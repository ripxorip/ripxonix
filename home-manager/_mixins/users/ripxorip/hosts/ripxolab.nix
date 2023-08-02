{ lib, pkgs, ... }:
{
  imports = [ ];
  dconf.settings = { };

  home = {
    packages = with pkgs; [
    ];
  };
}
