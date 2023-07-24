{ config, lib, pkgs, ... }: {
  imports = [
    ./tmux.nix
    ./zsh.nix
  ];
  home = {
    file = {
      "${config.xdg.configHome}/starship.toml".text = builtins.readFile ./starship.toml;
    };

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

  programs.starship = {
    enable = false;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
