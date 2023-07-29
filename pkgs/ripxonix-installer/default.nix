{ lib
, pkgs
, ...
}:
let
  ripxonix-installer = (pkgs.writeScriptBin "ripxonix-installer" (builtins.readFile ./ripxonix-installer.sh)).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in
{
  environment = {
    systemPackages = [
      ripxonix-installer
    ];
  };
}
