{ lib
, makeWrapper
, rebar3
, mixRelease
, elixir
, erlang
, fetchMixDeps
, fetchgit
, ...
}:
let
  livebook = mixRelease rec {
    pname = "livebook";
    version = "0.8.0";

    inherit elixir;

    buildInputs = [ erlang ];

    nativeBuildInputs = [ makeWrapper ];

    src = fetchgit {
      url = "https://github.com/livebook-dev/livebook.git";
      rev = "v${version}";

      sha256 = "0HsJGve4sLQ9cXpwwmMyo4R/wHaCwr22N32OX7O//oo=";
    };

    mixFodDeps = fetchMixDeps {
      pname = "mix-deps-${pname}";
      inherit src version;
      sha256 = "tWJ4Rdv4TAY/6XI8cI7/GUfRXW34vrx2ZXlJYxDSGsU=";
    };

    installPhase = ''
      mix escript.build
      mkdir -p $out/bin
      mv ./livebook $out/bin

      wrapProgram $out/bin/livebook \
        --suffix PATH : ${lib.makeBinPath [ elixir ]} \
        --set MIX_REBAR3 ${rebar3}/bin/rebar3
    '';
  };
in
livebook
