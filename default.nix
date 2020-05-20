super: self:

rec {
  fetchMixDeps = super.beam.packages.erlang.callPackage lib/fetch-mix-deps.nix {};
  buildMix = super.beam.packages.erlang.callPackage lib/build-mix.nix { inherit fetchMixDeps; };
}
