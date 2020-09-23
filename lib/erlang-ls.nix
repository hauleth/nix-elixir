{ rebar3Relx, fetchFromGitHub, git, cacert }:

let
  json = builtins.fromJSON (builtins.readFile ./json/erlang-ls.json);
in rebar3Relx rec {
  name = "erlang-ls";
  version = json.rev;
  releaseType = "escript";

  nativeBuildInputs = [ git cacert ];

  src = fetchFromGitHub json;
}
