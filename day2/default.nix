{ mkDerivation, base, optparse-applicative, stdenv }:
mkDerivation {
  pname = "day2";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base optparse-applicative ];
  homepage = "https://github.com/corkyuy/adventcode2017";
  description = "Advent Code 2017 day 2";
  license = stdenv.lib.licenses.bsd3;
}
