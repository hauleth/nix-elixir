self: super:

let
  packagesWith = erlang: let
    packages = super.beam.packagesWith erlang;
  in packages // rec {
    fetchMixDeps = packages.callPackage lib/fetch-mix-deps.nix {};
    buildMix' = packages.callPackage lib/build-mix.nix { inherit fetchMixDeps; };
    elixir-ls = packages.callPackage lib/elixir-ls.nix { inherit buildMix'; };
    erlang-ls = packages.callPackage lib/erlang-ls.nix {};
  };
  packages = super.lib.attrsets.mapAttrs (name: _: packagesWith super.beam.interpreters.${name}) super.beam.packages;
in {
  beam = super.beam // {
    inherit packagesWith packages;
  };

  inherit (packages.erlang) elixir-ls erlang-ls;
}
