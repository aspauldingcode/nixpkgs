{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, glib
, bison
, flex
, autoconf-archive
, graphviz
, vala
}:

# Frida's custom Vala compiler with features not yet upstream
# This is required to build frida-core as it checks for the '-frida' version suffix
stdenv.mkDerivation rec {
  pname = "frida-vala";
  version = "0.58.0-frida";

  src = fetchFromGitHub {
    owner = "frida";
    repo = "vala";
    rev = "9feabf0f8076c33b702d7cba612edfe0c1e45a00";
    sha256 = "sha256-Ag4Hnw3xBlhnQ91/0+92Z/bY11oDj9tmVa68XLSkgTY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bison
    flex
    vala  # Need vala to bootstrap the build
    autoconf-archive
  ];

  buildInputs = [
    glib
    graphviz
  ];

  # Use Meson build system (not autotools) to get the proper '-frida' version suffix
  # This is critical for frida-core compatibility

  meta = with lib; {
    description = "Frida's custom Vala compiler with features not yet upstream";
    longDescription = ''
      This is Frida's fork of the Vala compiler that includes features
      not yet available in upstream Vala. It's specifically required
      to build frida-core, which checks for the '-frida' version suffix.
      
      The package must be built with Meson (not autotools) to ensure
      the proper version suffix is applied.
    '';
    homepage = "https://github.com/frida/vala";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ aspauldingcode ];
    platforms = platforms.unix;
  };
}