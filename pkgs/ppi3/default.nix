{ stdenv, lib, fetchFromGitHub, bash, coreutils }:

let version = "0.1"; in stdenv.mkDerivation {
  inherit version;
  pname = "ppi3";

  src = fetchFromGitHub {
    owner = "tckmn";
    repo = "ppi3";
    rev = "v${version}";
    sha256 = "15vnfc1dnk3njy4jzyaz0ganx3y84q9q99zgshmsv1w4mircmd77";
  };

  builder = "${bash}/bin/bash";
  PATH = coreutils + /bin;
  args = [ "-c" "mkdir -p $out/bin && cp $src/ppi3.rb $out/bin/ppi3" ];

  meta = with lib; {
    description = "Preprocessor for the i3 window manager";
    homepage    = https://github.com/tckmn/ppi3;
    license     = licenses.gpl3;
    maintainers = [ maintainers.tckmn ];
    platforms   = platforms.all;
  };
}
