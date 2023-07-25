{ config, lib, pkgs, ... }: {
  programs.neovim = {
    package = pkgs.neovim;
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
    ];

    extraPackages = with pkgs; [
    ];

    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
    };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}