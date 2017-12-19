{ mkDerivation, base, stdenv }:
mkDerivation {
  pname = "day1";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  homepage = "https://github.com/corkyuy/adventcode2017";
  description = "Advent of Code";
  license = stdenv.lib.licenses.bsd3;
}
