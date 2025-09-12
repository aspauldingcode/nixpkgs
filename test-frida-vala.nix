let
  pkgs = import ./. {};
in
  pkgs.callPackage ./pkgs/development/compilers/frida-vala/default.nix {}