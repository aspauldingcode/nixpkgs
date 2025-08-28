{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, glib
, json-glib
, libsoup_3
, sqlite
, vala
, gobject-introspection
, glib-networking
, openssl
, zlib
, libffi
, pcre2
, util-linux
}:

# Frida Core - Dynamic instrumentation toolkit core library
#
# CURRENT STATUS: This package is marked as broken because Frida requires
# a custom Vala compiler with features not yet available upstream.
#
# TO FIX: The custom Vala compiler needs to be packaged from:
# https://github.com/frida/vala
#
# This derivation provides the basic structure and dependencies needed
# for frida-core, but cannot currently build due to the Vala requirement.

stdenv.mkDerivation rec {
  pname = "frida-core";
  version = "16.5.9";

  src = fetchFromGitHub {
    owner = "frida";
    repo = "frida-core";
    rev = "abc464bf49e1013fc4573c1488b86ecd31231c47";
    hash = "sha256-vpyz8DpPvRdmWmsNxLprdKGdANiKciAK8W5mP+BvIyM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    json-glib
    libsoup_3
    sqlite
    glib-networking
    openssl
    zlib
    libffi
    pcre2
  ] ++ lib.optionals stdenv.isLinux [
    util-linux
  ];

  mesonFlags = [
    "-Dhelper_modern=enabled"
    "-Dhelper_legacy=disabled"
    "-Dconnectivity=enabled"
    "-Dmapper=auto"
    "-Dtests=disabled"
    "-Dfrida_version=${version}"
  ];

  # Frida requires specific build environment setup
  preConfigure = ''
    export FRIDA_VERSION=${version}
    export FRIDA_TOOLCHAIN=gnu
    # Note: Frida officially requires a custom Vala compiler from https://github.com/frida/vala
    # This build may fail due to missing Vala features, but we'll try with standard Vala first
  '';

  # Skip tests for now as they require special setup
  doCheck = false;

  meta = with lib; {
    description = "Dynamic instrumentation toolkit core library";
    longDescription = ''
      Frida Core is the C/Vala library that provides the core functionality
      for the Frida dynamic instrumentation toolkit. It enables you to inject
      snippets of JavaScript or your own library into native apps on Windows,
      macOS, GNU/Linux, iOS, Android, and QNX.
      
      Note: This package currently cannot be built because Frida requires
      a custom Vala compiler with features not yet upstream. The required
      compiler can be found at: https://github.com/frida/vala
    '';
    homepage = "https://frida.re/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ ]; # TODO: Add maintainer
    platforms = platforms.unix;
    broken = true; # Requires custom Frida Vala compiler
  };
}