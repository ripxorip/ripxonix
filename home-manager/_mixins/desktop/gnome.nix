{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "eurosign:e" "caps:ctrl_modifier" ];
      sources = [ (mkTuple [ "xkb" "rip" ]) ];
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

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = lib.hm.gvariant.mkString "F9";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a start_dictation -e win11_swe";
      name = lib.hm.gvariant.mkString "Ripxospeech Stop";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = lib.hm.gvariant.mkString "F10";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a start_dictation -e talon_dictation";
      name = lib.hm.gvariant.mkString "Ripxospeech Stop";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = lib.hm.gvariant.mkString "F11";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a start_dictation -e talon_command";
      name = lib.hm.gvariant.mkString "Ripxospeech Stop";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = lib.hm.gvariant.mkString "F12";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a stop_dictation";
      name = lib.hm.gvariant.mkString "Ripxospeech Start";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = lib.hm.gvariant.mkString "F8";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a start_dictation -e gdocs";
      name = lib.hm.gvariant.mkString "Ripxospeech Start";
    };
  };

  gtk = { };

  home.file = { };
}
