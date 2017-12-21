{ mkDerivation, base, optparse-applicative, stdenv }:
mkDerivation {
  pname = "day3";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base optparse-applicative ];
  homepage = "https://github.com/corkyuy/adventcode2017";
  description = "Advent code 2017 day 3 solution";
  license = stdenv.lib.licenses.bsd3;
}
