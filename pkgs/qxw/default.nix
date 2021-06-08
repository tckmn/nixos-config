{ stdenv, lib, fetchurl, pkg-config, gtk2, pcre }:

let version = "20190722"; in stdenv.mkDerivation {
  inherit version;
  pname = "qxw";

  src = fetchurl {
    url = "https://www.quinapalus.com/qxw-${version}.tar.gz";
    sha256 = "0ccmrpz5v8r7bgdvlg92vsx4q78cm03b4rajdlfvd9xvn1rlcc16";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 pcre ];

  makeFlags = [ "DESTDIR=$(out)" ];

  patchPhase = ''
    sed -i 's/ `dpkg-buildflags[^`]*`//g;
            /mkdir -p/d;
            s/cp -a/install -D/;
            s,/usr/games,/bin,' Makefile
  '';

  meta = with lib; {
    description = "A program to help create and publish crosswords";
    homepage    = https://www.quinapalus.com/qxw.html;
    license     = licenses.gpl2;
    maintainers = [ maintainers.tckmn ];
    platforms   = platforms.linux;
  };
}
