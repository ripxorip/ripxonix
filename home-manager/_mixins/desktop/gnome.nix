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
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = lib.hm.gvariant.mkString "F1";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f1";
      name = lib.hm.gvariant.mkString "Ripxospeech F1";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = lib.hm.gvariant.mkString "F2";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f2";
      name = lib.hm.gvariant.mkString "Ripxospeech F2";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = lib.hm.gvariant.mkString "F3";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f3";
      name = lib.hm.gvariant.mkString "Ripxospeech F3";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = lib.hm.gvariant.mkString "F4";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f4";
      name = lib.hm.gvariant.mkString "Ripxospeech F4";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = lib.hm.gvariant.mkString "F8";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f8";
      name = lib.hm.gvariant.mkString "Ripxospeech F8";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = lib.hm.gvariant.mkString "F9";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f9";
      name = lib.hm.gvariant.mkString "Ripxospeech F9";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      binding = lib.hm.gvariant.mkString "F10";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f10";
      name = lib.hm.gvariant.mkString "Ripxospeech F10";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
      binding = lib.hm.gvariant.mkString "F11";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f11";
      name = lib.hm.gvariant.mkString "Ripxospeech F11";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8" = {
      binding = lib.hm.gvariant.mkString "F12";
      command = lib.hm.gvariant.mkString "/home/ripxorip/dev/ripxospeech/ripxospeech.py -a command_key -k f12";
      name = lib.hm.gvariant.mkString "Ripxospeech F12";
    };

  };

  gtk = { };

  home.file = { };
}
