{ lib, python39Packages, python, pkg-config, libX11
, SDL, SDL2, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi, freetype
}:

python39Packages.buildPythonPackage rec {
  pname = "pygame";
  version = "2.0.1";

  src = python39Packages.fetchPypi {
    inherit pname version;
    sha256 = "00a03qa7gva5r9m54gdx08cfyiw7fw3b4cwrhkccvbvsyiipn7lb";
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
