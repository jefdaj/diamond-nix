let
  sources = import ./nix/sources.nix {};
  pkgs    = import sources.nixpkgs {};
  diamond = pkgs.callPackage ./default.nix {};
in
  diamond
