let
  pkgs = import <nixpkgs> {};
in
  { day3 = pkgs.haskellPackages.callPackage ./default.nix {};
  }
