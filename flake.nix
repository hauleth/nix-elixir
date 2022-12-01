{
  description = "Elixir utilities";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = import ./pkgs;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
      in
      {
        legacyPackages = pkgs;

        packages = rec {
          livebook = pkgs.livebook;
        };

        templates = {
          elixir = {
            path = ./templates/elixir;
            description = "Basic flake for Elixir applications";
          };
        };
      }
    );
}
