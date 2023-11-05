{ lib, pkgs, ... }:
{
  imports = [ ];
  programs.git.extraConfig = {
    safe = {
      directory = "/home/ripxorip/dev/migic.com";
    };
  };
}
