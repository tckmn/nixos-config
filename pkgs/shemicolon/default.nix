{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "shemicolon";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "tckmn";
    repo = "shemicolon";
    rev = "114d2fc9d7b8cc5b617ae44ad6a651ca6a4d89c8";
    sha256 = "sha256-Ovz2z4qW/1vRn6xhMuhpds1yyL6FuBpfhcKQHWzahtk=";
  };

  installPhase = ''
    install -D shemicolon.zsh -t $out/share/shemicolon
  '';

  meta = with lib; {
    description = "zsh tool that binds various shortcuts to semicolon typed at an empty prompt";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tckmn ];
  };
}
