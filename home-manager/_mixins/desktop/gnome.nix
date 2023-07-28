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
    "org/gnome/shell" = {
      welcome-dialog-last-shown-version = lib.hm.gvariant.mkString "44.2";
    };
    "org/gnome/desktop/background" = {
      color-shading-type = lib.hm.gvariant.mkString "solid";
      picture-options = lib.hm.gvariant.mkString "zoom";
      picture-uri = lib.hm.gvariant.mkString "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = lib.hm.gvariant.mkString "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = lib.hm.gvariant.mkString "#241f31";
      secondary-color = lib.hm.gvariant.mkString "#000000";
    };


  };

  gtk = { };

  home.file = { };
}
