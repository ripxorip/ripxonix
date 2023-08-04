{ lib
, stdenv
, fetchFromGitHub
, nixosTests
, makeWrapper
, zfs
, perlPackages
, procps
, which
, openssh
, mbuffer
, pv
, lzop
, gzip
, pigz
}:

stdenv.mkDerivation rec {
  pname = "syncoid";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "jimsalterjrs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qfRGZ10fhLL4tJL97VHrdOkO/4OVpa087AsL9t8LMmk=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [ perl ConfigIniFiles CaptureTiny ];

  passthru.tests = nixosTests.sanoid;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"

    install -m755 syncoid "$out/bin/syncoid"
    wrapProgram "$out/bin/syncoid" \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${lib.makeBinPath [ openssh procps which pv mbuffer lzop gzip pigz zfs ]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Custom build of syncoid to work around the sudo bug";
    homepage = "https://github.com/jimsalterjrs/sanoid";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ripxorip ];
    platforms = platforms.all;
  };
}
