{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  version = "1.2.0";
  pname = "tgcrypto";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "tgcrypto";
    rev = "v${version}";
    sha256 = "1vslq0s3jjir5rb20fh6v52i4m7klkksbyz3w8val8ghbii212dk";
  };

  # propagatedBuildInputs = with python3Packages; [ pyaes pysocks ];

  meta = with lib; {
    description = "Simple python script to download Bandcamp albums";
    homepage    = https://github.com/iheanyi/bandcamp-dl;
    license     = licenses.unlicense;
    maintainers = [ maintainers.tckmn ];
    platforms   = platforms.all;
  };
}
