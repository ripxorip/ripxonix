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
  name = "matrix.sh";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "fabianonline";
    repo = "matrix.sh";
    rev = "af1c286c63f2a37392320cb3fe25251e6b52e540";
    # sha256 = fakeSha256; # To get the initial fail and the real sha256
    sha256 = "sha256-1mz52n/0ZZtQZo83EMKbHycvilvMTmyrtDCW5YxYjj0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm 0755 matrix.sh $out/bin/matrix.sh
    wrapProgram $out/bin/matrix.sh --set PATH \
      "${makeBinPath [
        hostname
        bash
        curl
        jq
        coreutils
      ]}"
  '';

  meta = {
    description = "Matrix.sh Nix package";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
