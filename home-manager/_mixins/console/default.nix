{ config, pkgs, lib, darkmode, ... }: {
  imports = [
    ./tmux.nix
    ./zsh.nix
    ./git.nix
    ./nvim
  ];
  home = {
    file = {
      "${config.xdg.configHome}/starship.toml".text = builtins.readFile ./starship.toml;
    };

    packages = with pkgs; [
      tldr
      starship
      fzf
      neofetch
      ripgrep
      eza
      fd
      bat
      delta
      btop
      tmux
      age
      bitwarden-cli
      key_extractor
      tokei
      du-dust
      radare2
      wireguard-tools
      jq
      dig
      matrix-sh
      wl-clipboard
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

  programs.bat = {
    enable = true;
    config = lib.mkIf (!darkmode) {
      theme = "GitHub";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
