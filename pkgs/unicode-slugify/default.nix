{ lib, python3Packages, fetchFromGitHub }:

with python3Packages; buildPythonPackage {
  pname = "unicode-slugify";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "unicode-slugify";
    rev = "b696c37d6f63a11cf1642d891d7443248cc147d1";
    sha256 = "1hq0ph074dgzjwkkj9007p7xl9zk589gvkr4ni7g1lwr97pd9yrl";
  };

  nativeBuildInputs = [ nose ];
  propagatedBuildInputs = [ six unidecode ];

  meta = with lib; {
    description = "A slugifier that works in unicode";
    homepage    = https://github.com/mozilla/unicode-slugify;
    license     = licenses.bsd3;
    maintainers = [ maintainers.tckmn ];
    platforms   = platforms.all;
  };
}
