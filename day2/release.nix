let
  pkgs = import <nixpkgs> {};
in
  { day2 = pkgs.haskellPackages.callPackage ./default.nix {};
  }
