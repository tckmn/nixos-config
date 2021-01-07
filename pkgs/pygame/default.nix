{ lib, python3Packages, python, pkg-config, libX11
, SDL, SDL2, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi, freetype
}:

python3Packages.buildPythonPackage rec {
  pname = "pygame";
  version = "2.0.0.dev10";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "12p0zagrhd0z1f28c5ia8yp7xjp8yw9l6jiw3qgkmrymqfh7shy4";
  };

  nativeBuildInputs = [
    pkg-config SDL SDL2.dev
    SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    portmidi libX11 freetype
  ];

  buildInputs = [
    SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    portmidi libX11 freetype
  ];

  # Tests fail because of no audio device and display.
  doCheck = false;

  preConfigure = ''
    sed \
      -e "s/origincdirs = .*/origincdirs = []/" \
      -e "s/origlibdirs = .*/origlibdirs = []/" \
      -e "/'\/lib/d" \
      -e "/\/include\/smpeg/d" \
      -e "s/.-auto. not in sys.argv/False/" \
      -i buildconfig/config_unix.py
    ${lib.concatMapStrings (dep: ''
      sed \
        -e "/origincdirs =/a\        origincdirs += ['${lib.getDev dep}/include']" \
        -e "/origlibdirs =/a\        origlibdirs += ['${lib.getLib dep}/lib']" \
        -i buildconfig/config_unix.py
      '') buildInputs
    }
    LOCALBASE=/ ${python.interpreter} buildconfig/config.py
  '';

  meta = with lib; {
    description = "Python library for games";
    homepage = http://www.pygame.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
