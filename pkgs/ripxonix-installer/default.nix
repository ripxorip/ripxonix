{ lib
, pkgs
, stdenv
, makeWrapper
, git
, coreutils
}:

with lib;

stdenv.mkDerivation {
  name = "ripxonix-installer";
  version = "1.0";
  src = ./ripxonix-installer.sh;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm 0755 $src $out/bin/ripxonix-installer
    wrapProgram $out/bin/ripxonix-installer --set PATH \
      "${
        makeBinPath [
          git
          coreutils
        ]
      }"
  '';

  meta = {
    description = "The ripxonix installer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}