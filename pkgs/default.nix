{ pkgs ? import <nixpkgs> { } }: rec {

  # Packages with an actual source

  # Personal scripts
  key_extractor = pkgs.callPackage ./key_extractor { };
  matrix-sh = pkgs.callPackage ./matrix.sh { };
  ripxobot = pkgs.callPackage ./ripxobot { };
  syncoid = pkgs.callPackage ./syncoid { };
  feed_fencer = pkgs.callPackage ./feed_fencer { };
  usbip_plugger = pkgs.callPackage ./usbip_plugger { };
}
