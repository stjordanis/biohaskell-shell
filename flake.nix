{

  description = "biohaskell-shell";

  nixConfig = {
    extra-substituters = "https://horizon.cachix.org";
    extra-trusted-public-keys = "horizon.cachix.org-1:MeEEDRhRZTgv/FFGCv3479/dmJDfJ82G6kfUDxMSAw0=";
  };

  inputs = {
    crazy-shell.url = "git+https://gitlab.homotopic.tech/crazy-shell/crazy-shell";
    flake-utils.url = "github:numtide/flake-utils";
    horizon-biohaskell.url = "git+https://gitlab.horizon-haskell.net/package-sets/horizon-biohaskell";
    lint-utils = {
      url = "git+https://gitlab.homotopic.tech/nix/lint-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    inputs@
    { self
    , crazy-shell
    , flake-utils
    , horizon-biohaskell
    , lint-utils
    , nixpkgs
    , ...
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      with crazy-shell.lib;
      let
        pkgs = import nixpkgs { inherit system; };

        haskellPackages = horizon-biohaskell.legacyPackages.${system};

        biohaskell-shell = import ./default.nix {
          inherit pkgs haskellPackages mkCrazyShell;
        };
      in
      {

        apps = {

          default = {
            type = "app";
            program = "${biohaskell-shell}/bin/biohaskell-shell";
          };

        };

        checks =
          with lint-utils.outputs.linters.${system}; {
            dhall-format = dhall-format { src = self; };
            nixpkgs-fmt = nixpkgs-fmt { src = self; };
            stylish-haskell = stylish-haskell { src = self; };
          };

        packages.default = biohaskell-shell;

      });
}
