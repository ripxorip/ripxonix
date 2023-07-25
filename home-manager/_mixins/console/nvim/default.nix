{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      gitsigns-nvim 
      catppuccin-nvim
      nvim-compe
vim-fugitive
suda-vim
nvim-autopairs
# FIXME These shall be created by me
#vim-ripgrep
#ripxorip/bolt
#ripxorip/aerojump
#ripxorip/utils
editorconfig-vim
neoformat
lsp_signature-nvim
vim-vsnip
nvim-treesitter.withAllGrammars
playground
fzf-vim
    ];

    extraPackages = with pkgs; [
      tree-sitter
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