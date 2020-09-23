{ rebar3Relx, fetchFromGitHub, gitMinimal }:

let
  json = builtins.fromJSON (builtins.readFile ./json/sourcer.json);
in rebar3Relx rec {
  name = "erlang-sourcer";
  version = json.rev;
  releaseType = "escript";

  nativeBuildInputs = [ gitMinimal ];

  src = fetchFromGitHub json;
}
