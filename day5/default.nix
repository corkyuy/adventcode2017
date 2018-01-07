{ mkDerivation, base, optparse-applicative, stdenv, transformers }:
mkDerivation {
  pname = "day5";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base optparse-applicative transformers
  ];
  description = "Advent code day 5";
  license = stdenv.lib.licenses.bsd3;
}
