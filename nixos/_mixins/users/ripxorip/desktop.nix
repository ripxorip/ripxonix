{ pkgs, ... }: {
  imports = [ ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    vscode
  ];
}
