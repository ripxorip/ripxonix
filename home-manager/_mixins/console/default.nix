{ config, lib, pkgs, ... }: {
  imports = [
    ./tmux.nix
    ./zsh.nix
    ./starship.nix
  ];
  home = {
    packages = with pkgs; [
      starship
      fzf
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
