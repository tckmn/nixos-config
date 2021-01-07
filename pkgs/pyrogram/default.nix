{ lib, python3Packages, fetchFromGitHub }:

let tgcrypto = (import <nixpkgs> {}).callPackage ../tgcrypto {}; in
python3Packages.buildPythonPackage rec {
  version = "0.17.1";
  pname = "pyrogram";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "pyrogram";
    rev = "v${version}";
    sha256 = "0x2mzysqlj0cjjx79fc95q8lskvpbmmyci0wp88xwp9b97v64sl4";
  };

  propagatedBuildInputs = with python3Packages; [ pyaes pysocks tgcrypto ];

  doCheck = false;

  meta = with lib; {
    description = "Simple python script to download Bandcamp albums";
    homepage    = https://github.com/iheanyi/bandcamp-dl;
    license     = licenses.unlicense;
    maintainers = [ maintainers.tckmn ];
    platforms   = platforms.all;
  };
}
