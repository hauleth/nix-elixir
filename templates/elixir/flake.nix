{
  description = "Elixir's application";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        erl = pkgs.beam.packages.erlang;
      in
      {
        devShell = pkgs.mkShell {
          packages =
            [
              erl.elixir
              erl.elixir_ls
            ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
              pkgs.darwin.apple_sdk.frameworks.CoreFoundation
              pkgs.darwin.apple_sdk.frameworks.CoreServices
            ];
        };
      }
    );
}
