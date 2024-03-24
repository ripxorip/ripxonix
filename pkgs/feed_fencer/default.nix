{ lib
, pkgs
, fetchFromGitHub
, stdenv
, makeWrapper
, coreutils
, curl
, hostname
, bash
, jq
}:

with lib;

stdenv.mkDerivation {
  name = "feed_fencer";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm 0755 ./feed_fencer.sh $out/bin/feed_fencer
  '';

  meta = {
    description = "Feed fencer Nix package";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
