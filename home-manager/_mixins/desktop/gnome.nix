{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options=["eurosign:e" "caps:ctrl_modifier"];
      sources=[ (mkTuple["xkb" "us+colemak_dh"])];
    };
  };

  gtk = { };

  home.file = { };
}
