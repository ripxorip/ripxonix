{ desktop, darkmode, pkgs, ... }:
let

  kitty_light_theme = "GitHub Light";
  kitty_light_theme_font = "Iosevka NF Bold";
  kitty_light_theme_font_size = 11;
  kitty_light_theme_window_decorations = "no";

  kitty_dark_theme = "Catppuccin-Macchiato";
  kitty_dark_theme_font = "Iosevka NF";
  kitty_dark_theme_font_size = 13;
  kitty_dark_theme_window_decorations = "yes";

  kitty_theme = if darkmode then kitty_dark_theme else kitty_light_theme;
  kitty_theme_font = if darkmode then kitty_dark_theme_font else kitty_light_theme_font;
  kitty_theme_font_size = if darkmode then kitty_dark_theme_font_size else kitty_light_theme_font_size;
  kitty_theme_window_decorations = if darkmode then kitty_dark_theme_window_decorations else kitty_light_theme_window_decorations;

in
{
  imports = [
    (./. + "/${desktop}.nix")
  ];
  home = {
    packages = with pkgs; [
      element-desktop
    ];
  };

  programs = {
    kitty = {
      enable = true;
      theme = kitty_theme;

      settings = {
        font_family = kitty_theme_font;
        font_size = kitty_theme_font_size;

        scrollback_lines = 10000;
        placement_strategy = "center";

        repaint_delay = 1;
        input_delay = 1;
        sync_to_monitor = "no";
        enable_audio_bell = "no";
        hide_window_decorations = kitty_theme_window_decorations;
        allow_remote_control = "yes";
      };

      keybindings = {
        "kitty_mod+equal" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
        "ctrl+f11" = "toggle_fullscreen";
      };
    };
  };
}
