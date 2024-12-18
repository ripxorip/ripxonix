{ lib
, pkgs
, stdenv
, makeWrapper
, coreutils
}:

with lib;

stdenv.mkDerivation {
  name = "usbip_plugger";
  version = "1.0";
  src = ./.;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ];

  # These dependencies are for experimenting and will be propagated for runtime.
  propagatedBuildInputs = [
    (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      pyqt5
    ]))
  ];

  installPhase = ''
    install -Dm755 ${./usbip_plugger.py} $out/bin/usbip_plugger

    wrapProgram $out/bin/usbip_plugger --set PATH \
          "${
            makeBinPath [
                pkgs.linuxPackages.usbip
            ]
          }" \
           --set QT_QPA_PLATFORM_PLUGIN_PATH "${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/"
  '';

  # Metadata for package information
  meta = {
    description = "Quick and dirty UI for being able to plug/unplug USBIP devices";
    license = licenses.mit;
    platforms = platforms.all;
  };

  # Add a `shellHook` for development
  shellHook = ''
    export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/"
    echo "Development shell ready. Run your script with 'python usbip_plugger.py'."
  '';
}
