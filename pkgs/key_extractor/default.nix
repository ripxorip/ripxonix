{ lib
, pkgs
, stdenv
, makeWrapper
, coreutils
, bitwarden-cli
}:

with lib;

stdenv.mkDerivation {
  name = "key_extractor";
  version = "1.0";
  src = ./.;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ];

  # These dependencies are not needed, just to experiment with nix
  propagatedBuildInputs = [
    (pkgs.python38.withPackages (pythonPackages: with pythonPackages; [
      consul
      six
    ]))
  ];

  installPhase = ''
    install -Dm755 ${./key_extractor.py} $out/bin/key_extractor
    wrapProgram $out/bin/key_extractor --set PATH \
          "${
            makeBinPath [
              bitwarden-cli
              coreutils
            ]
          }"
  '';

  meta = {
    description = "A program that extracts my private key from bitwarden and make it available to agenix";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
