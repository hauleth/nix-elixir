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
    version = "0.7.2";

    inherit elixir;

    buildInputs = [ erlang ];

    nativeBuildInputs = [ makeWrapper ];

    src = fetchgit {
      url = "https://github.com/livebook-dev/livebook.git";
      rev = "v${version}";

      sha256 = "iKD5u/8XCXBXNA588jXji9Kf7zRHGO5D89HsqErQnp0=";
    };

    mixFodDeps = fetchMixDeps {
      pname = "mix-deps-${pname}";
      inherit src version;
      sha256 = "5EQk4RACPTZyOF+fSnUTSHuHt6exmXkBtIyXwVay6lk=";
    };

    installPhase = ''
      mix escript.build
      mkdir -p $out/bin
      mv ./livebook $out/bin

      wrapProgram $out/bin/livebook \
        --prefix PATH : ${lib.makeBinPath [ elixir ]} \
        --set MIX_REBAR3 ${rebar3}/bin/rebar3
    '';
  };
in
livebook
