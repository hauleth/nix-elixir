# Nix derivations for Mix projects

Simple Nix derivation for building Mix release:

```nix
let
  mixOverlay = builtins.fetchGit {
    url = "https://github.com/hauleth/nix-elixir.git";
  };
  nixpkgs = import <nixpkgs> {
    overlays = [ (import mixOverlay) ];
  };
  packages = nixpkgs.beam.packagesWith nixpkgs.beam.interpreters.erlang;
in

packages.buildMix {
  pname = "my-project";
  version = "1.2.3";
}
```

## Provided derivations and functions

- `fetchMixDeps` - fetch dependencies specified by Mix
- `buildMix'` - build Mix package using Mix releases
- `elixir-ls` - Language Server implementation for Elixir
- `sourcer` - Language Server implementation for Erlang
- `erlang-ls` - Language Server implementation for Erlang
