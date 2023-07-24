{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Continue here with oh-my-zsh plugins, etc.
      eval "$(starship init zsh)"
    '';
  };
}