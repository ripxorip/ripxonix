_: {
  programs = {
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          features = "decorations";
          navigate = true;
          side-by-side = true;
        };
      };
      aliases = {
        adog = "log --all --decorate --oneline --graph";
        co = "checkout";
      };
      userEmail = "ripxorip@gmail.com";
      userName = "Philip K. Gisslow";
      extraConfig = {
        push = {
          default = "matching";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "master";
        };
      };
    };
  };
}
