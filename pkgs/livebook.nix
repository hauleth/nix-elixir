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
    version = "0.10.0";

    inherit elixir;

    buildInputs = [ erlang ];

    nativeBuildInputs = [ makeWrapper ];

    src = fetchgit {
      url = "https://github.com/livebook-dev/livebook.git";
      rev = "v${version}";

      sha256 = "sha256-Bp1CEvVv5DPDDikRPubsG6p4LLiHXTEXE+ZIip3LsGA=";
    };

    mixFodDeps = fetchMixDeps {
      pname = "mix-deps-${pname}";
      inherit src version;
      sha256 = "sha256-qFLCWr7LzI9WNgj0AJO3Tw7rrA1JhBOEpX79RMjv2nk=";
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
