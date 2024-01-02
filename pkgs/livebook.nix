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
    version = "0.12.1";

    inherit elixir;

    buildInputs = [ erlang ];

    nativeBuildInputs = [ makeWrapper ];

    src = fetchgit {
      url = "https://github.com/livebook-dev/livebook.git";
      rev = "v${version}";

      sha256 = "sha256-Q4c0AelZZDPxE/rtoHIRQi3INMLHeiZ72TWgy183f4Q=";
    };

    mixFodDeps = fetchMixDeps {
      pname = "mix-deps-${pname}";
      inherit src version;
      sha256 = "sha256-dyKhrbb7vazBV6LFERtGHLQXEx29vTgn074mY4fsHy4=";
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
