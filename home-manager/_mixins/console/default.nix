{ config, lib, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      neofetch
      ripgrep
      tmux
    ];

    sessionVariables = {
      EDITOR = "vim";
      SYSTEMD_EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
