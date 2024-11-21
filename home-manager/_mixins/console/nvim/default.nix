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

in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      bolt
      copilot-lua
      CopilotChat-nvim
      ChatGPT-nvim
      nvim-lspconfig
      gitsigns-nvim
      catppuccin-nvim
      nvim-compe
      vim-fugitive
      vim-suda
      nvim-autopairs
      vim-ripgrep
      github-nvim-theme
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
  };

  xdg.configFile."nvim/init.lua" = {
    # source = ./init.lua;
    # Absolute for now so I dont have to generate all the time during development
    source = config.lib.file.mkOutOfStoreSymlink /home/ripxorip/dev/ripxonix/home-manager/_mixins/console/nvim/init.lua;
  };
}
