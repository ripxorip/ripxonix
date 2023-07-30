{ pkgs, ... }: {
  imports = [ ];

  environment.systemPackages = with pkgs; [
    unstable.vscode-fhs
  ];
}
