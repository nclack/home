{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation {
  pname = "fredoka-one";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/google/fonts/raw/refs/heads/main/ofl/fredoka/Fredoka%5Bwdth,wght%5D.ttf";
    hash = "sha256-K6AuaLFShorvm6KOJLNkjH1Ff+byXHYfLCxT+2GnP8g=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src "$out/share/fonts/truetype/FredokaOne-Regular.ttf"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fredoka One font";
    homepage = "https://fonts.google.com/specimen/Fredoka+One";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
} 