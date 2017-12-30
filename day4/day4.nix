{ mkDerivation, base, mtl, optparse-applicative, stdenv }:
mkDerivation {
  pname = "day4";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base mtl optparse-applicative ];
  homepage = "https://github.com/corkyuy/adventcode2017";
  description = "Advent Code 2017 Day3";
  license = stdenv.lib.licenses.bsd3;
}
