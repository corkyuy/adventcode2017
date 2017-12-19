let
  pkgs = import <nixpkgs> {};
in
  { day1 = pkgs.haskellPackages.callPackage ./default.nix {};
  }
