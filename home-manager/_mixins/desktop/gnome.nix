{ config, lib, pkgs, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {};

  gtk = {};

  home.file = {};
}
