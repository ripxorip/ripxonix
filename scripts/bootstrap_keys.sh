#!/usr/bin/env sh
cd pkgs/key_extractor/
nix-build -E "with import <nixpkgs> {}; callPackage ./default.nix {}"
./result/bin/key_extractor
