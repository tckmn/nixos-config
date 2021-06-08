{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "shemicolon";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "tckmn";
    repo = "shemicolon";
    rev = "7f95c6f6bee6dbdd6ff850ced74e6d76cfa10877";
    sha256 = "1xjj722w1h5mc48g0sx5np333b1jkgny590ay2bfj3km648p7c4z";
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
