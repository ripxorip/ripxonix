{ desktop, pkgs, ... }: {
  imports = [
    (./. + "/${desktop}.nix")
  ];
  home = {
    packages = with pkgs; [];
  };

  programs = {
    kitty = {
      enable = true;
      theme = "Catppuccin-Macchiato";

      settings = {
        font_family = "Iosevka NF";
        font_size = 13;

        scrollback_lines = 10000;
        placement_strategy = "center";

        visual_bell_duration = "0.1";

        repaint_delay = 1;
        input_delay = 1;
        sync_to_monitor = "no";
        enable_audio_bell = "no";
        hide_window_decorations = "yes";
        allow_remote_control = "yes";
      };

      keybindings = {
        "kitty_mod+equal" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
        "ctrl+f11" =    "toggle_fullscreen";
      };
    };
  };
}