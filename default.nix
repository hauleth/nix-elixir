self: super:

{
  beam = super.beam // {
    packagesWith = erlang: let
      packages = super.beam.packagesWith erlang;
    in packages // rec {
      fetchMixDeps = packages.callPackage lib/fetch-mix-deps.nix {};
      buildMix' = packages.callPackage lib/build-mix.nix { inherit fetchMixDeps; };
      elixir-ls = packages.callPackage lib/elixir-ls.nix { inherit buildMix'; };
      sourcer = packages.callPackage lib/sourcer.nix {};
      erlang-ls = packages.callPackage lib/erlang-ls.nix {};
    };
  };
}
