{ lib
, pkgs
, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, tailscale
, matrix-sh
}:

with lib;

stdenv.mkDerivation {
  name = "ripxobot";
  version = "1.0";

  src = builtins.fetchGit {
    url = "git@github.com:ripxorip/ripxobot.git";
    rev = "dc4cf96ad54e72e4e76e5767840b2ace47fcd75b";
    allRefs = true;
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [
    pkgs.python3
  ];

  # These dependencies are not needed, just to experiment with nix
  installPhase = ''
    install -Dm755 housekeeper.py $out/bin/ripxobot-housekeeper
    wrapProgram $out/bin/ripxobot-housekeeper --set PATH \
          "${
            makeBinPath [
              matrix-sh
              coreutils
              tailscale
            ]
          }"
  '';

  meta = {
    description = "My bot";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
