{ pkgs, ... }:
let
  bolt = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "bolt";
    src = pkgs.fetchFromGitHub {
      owner = "ripxorip";
      repo = "bolt.nvim";
      rev = "aecf421d9916c2480bd2bd1f86560634379cc671";
      hash = "sha256-z7/3+/WMlJGQf8VzGgPTpjydFbQsDdCm6IftnZ0K6k4=";
    };
  };
  vim-ripgrep = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-ripgrep-2021-11-30";
    src = pkgs.fetchFromGitHub {
      owner = "jremmen";
      repo = "vim-ripgrep";
      rev = "2bb2425387b449a0cd65a54ceb85e123d7a320b8";
      sha256 = "sha256-OvQPTEiXOHI0uz0+6AVTxyJ/TUMg6kd3BYTAbnCI7W8=";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      bolt
      nvim-lspconfig
      gitsigns-nvim
      catppuccin-nvim
      nvim-compe
      vim-fugitive
      suda-vim
      nvim-autopairs
      vim-ripgrep
      # FIXME These shall be created by me
      #vim-ripgrep
      #ripxorip/aerojump
      #ripxorip/utils
      editorconfig-vim
      neoformat
      lsp_signature-nvim
      vim-vsnip
      nvim-treesitter.withAllGrammars
      playground
      fzf-vim
      vim-tmux-navigator
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
