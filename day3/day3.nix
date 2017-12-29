{ mkDerivation, base, cereal, containers, grid, mtl
, optparse-applicative, stdenv, unordered-containers
}:
mkDerivation {
  pname = "day3";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base cereal containers grid mtl optparse-applicative
    unordered-containers
  ];
  homepage = "https://github.com/corkyuy/adventcode2017";
  description = "Advent code 2017 day 3 solution";
  license = stdenv.lib.licenses.bsd3;
}
