let
  nixpkgs = import <nixpkgs> { overlays = [(import ./.)]; };
  packages = nixpkgs.beam.packagesWith nixpkgs.beam.interpreters.erlang;
in
  {
    inherit (packages) elixir-ls erlang-ls;
  }
