{ pkgs, darkmode, config, ... }:
let
  bolt = pkgs.vimUtils.buildVimPlugin {
    name = "bolt";
    src = pkgs.fetchFromGitHub {
      owner = "ripxorip";
      repo = "bolt.nvim";
      rev = "aecf421d9916c2480bd2bd1f86560634379cc671";
      hash = "sha256-z7/3+/WMlJGQf8VzGgPTpjydFbQsDdCm6IftnZ0K6k4=";
    };
  };
  github-nvim-theme = pkgs.vimUtils.buildVimPlugin {
    name = "GitHub Light";
    src = pkgs.fetchFromGitHub {
      owner = "projekt0n";
      repo = "github-nvim-theme";
      rev = "806903c1b66a6b29347871922acd7d830a9d5c6a";
      sha256 = "sha256-F0oDNVFw1yExgGD0hPWAvTgi55H/gY0i072nSCs33j4=";
    };
  };
  vim-ripgrep = pkgs.vimUtils.buildVimPlugin {
    name = "vim-ripgrep-2021-11-30";
    src = pkgs.fetchFromGitHub {
      owner = "jremmen";
      repo = "vim-ripgrep";
      rev = "2bb2425387b449a0cd65a54ceb85e123d7a320b8";
      sha256 = "sha256-OvQPTEiXOHI0uz0+6AVTxyJ/TUMg6kd3BYTAbnCI7W8=";
    };
  };

  colorscheme_darkmode = ''
    local utils = require('utils')
    local cmd = vim.cmd

    utils.opt('o', 'termguicolors', true)
    utils.opt('o', 'background', 'dark')
    -- cmd 'colorscheme onedark'

    vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

    require("catppuccin").setup()

    vim.cmd [[colorscheme catppuccin]]
  '';

  colorscheme_light_mode = ''
    local utils = require('utils')
    local cmd = vim.cmd

    --utils.opt('o', 'termguicolors', true)
    --utils.opt('o', 'background', 'dark')
    -- cmd 'colorscheme onedark'

    -- vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

    require("catppuccin").setup()

    require('github-theme').setup({
        options = {
            hide_nc_statusline = false,

        },
    })

    vim.cmd [[colorscheme github_light]]
    vim.cmd ('set laststatus=0')
    -- vim.cmd('colorscheme github_light')
  '';

  nvim_colorscheme = if darkmode then colorscheme_darkmode else colorscheme_light_mode;

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
      github-nvim-theme
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
      vim-unimpaired
    ];

    extraPackages = with pkgs; [
      tree-sitter
    ];

    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
  };


  home = {
    file = {
      "${config.xdg.configHome}/nvim/lua/config/colorscheme.lua".text = "${nvim_colorscheme}";
    };
  };

  # FIXME Continue here, by generating the colorscheme.lua file according to the darkmode variable
  # It shall be written and probably be removed from the local .config folder
  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
