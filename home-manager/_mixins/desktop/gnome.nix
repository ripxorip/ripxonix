{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "eurosign:e" "caps:ctrl_modifier" ];
      sources = [ (mkTuple [ "xkb" "us+colemak_dh" ]) ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 257;
      repeat-interval = lib.hm.gvariant.mkUint32 23;
    };
  };

  gtk = { };

  home.file = { };
}
