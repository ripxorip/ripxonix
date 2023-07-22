{ desktop, pkgs, lib, ... }: {
  imports = [];

  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    vscode
  ];
}
