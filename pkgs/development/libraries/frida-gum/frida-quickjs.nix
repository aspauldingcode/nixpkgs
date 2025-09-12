{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "frida-quickjs";
  version = "12de2e4904b63405052508c891b215d056962c18";

  src = fetchFromGitHub {
    owner = "frida";
    repo = "quickjs";
    rev = version;
    hash = "sha256-rsOZJXUW5Iserfjr8FuiH+uefJ1wDH5I0xHz6MtSHuo=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildPhase = ''
    runHook preBuild
    make all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install PREFIX=$out
    runHook postInstall
  '';

  enableParallelBuilding = true;

  strictDeps = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace "CONFIG_LTO=y" ""
  '';

  meta = with lib; {
    description = "Frida's fork of QuickJS - Small and embeddable Javascript engine";
    homepage = "https://github.com/frida/quickjs";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aspauldingcode ];
  };
}