{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "lwip";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lwip-tcpip";
    repo = "lwip";
    rev = "STABLE-2_2_0_RELEASE";
    sha256 = "sha256-ZUnFmvzC4Pg4v+oGm3mb1GdPX0s2ycJg4kXnN6a9a/w=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    
    # Install headers
    mkdir -p $out/include/lwip
    cp -r src/include/lwip/* $out/include/lwip/
    
    # Create a minimal pkg-config file for lwip
    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/lwip.pc << EOF
prefix=$out
exec_prefix=\$\{prefix\}
libdir=\$\{exec_prefix\}/lib
includedir=\$\{prefix\}/include

Name: lwIP
Description: A Lightweight TCP/IP stack
Version: ${version}
Libs: 
Cflags: -I\$\{includedir\}
EOF
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Lightweight TCP/IP stack";
    homepage = "https://savannah.nongnu.org/projects/lwip/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}