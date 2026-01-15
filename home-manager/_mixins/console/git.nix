{ darkmode, ... }: {
  programs = {
    delta = {
      enable = true;
      options = {
        features = "decorations";
        navigate = true;
        side-by-side = true;
        light = !darkmode;
      };
    };

    git = {
      enable = true;
      settings = {
        push = {
          default = "matching";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "master";
        };
        alias = {
          adog = "log --all --decorate --oneline --graph";
          co = "checkout";
        };
        user.email = "ripxorip@gmail.com";
        user.name = "Philip K. Gisslow";
      };
    };
  };
}
