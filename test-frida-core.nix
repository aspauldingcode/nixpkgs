# Test script for frida-core package
# Usage: nix-build test-frida-core.nix

with import <nixpkgs> {};

let
  frida-core = callPackage ./pkgs/development/libraries/frida-core {};
in
  frida-core