{ lib, python3Packages, fetchFromGitHub }:

let version = "0.0.8-12";
    unicode-slugify = (import <nixpkgs> {}).callPackage ../unicode-slugify {}; in
python3Packages.buildPythonApplication {
  inherit version;
  pname = "bandcamp-dl";

  src = fetchFromGitHub {
    owner = "iheanyi";
    repo = "bandcamp-dl";
    rev = "v${version}";
    sha256 = "1splh2nw0fx40j0vz8psnizg4723ccf2r4kzzl4dnh5gzsbgkhwj";
  };

  propagatedBuildInputs = with python3Packages; [ setuptools beautifulsoup4 docopt mutagen requests unicode-slugify mock chardet ];

  patches = [ ./remove-demjson.patch ];

  meta = with lib; {
    description = "Simple python script to download Bandcamp albums";
    homepage    = https://github.com/iheanyi/bandcamp-dl;
    license     = licenses.unlicense;
    maintainers = [ maintainers.tckmn ];
    platforms   = platforms.all;
  };
}
