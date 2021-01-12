{ elixir, fetchFromGitHub, buildMix' }:

let
  json = builtins.fromJSON (builtins.readFile ./json/elixir-ls.json);
in
buildMix' {
  pname = "elixir-ls";
  version = json.rev;

  # temporary fix for elixir-lang/elixir#10517
  impureMixRebar = true;

  # refresh: nix-prefetch-git https://github.com/elixir-lsp/elixir-ls.git [--rev branchName | --rev sha]
  src = fetchFromGitHub json;

  mixSha256 = "1bdyqg20hj6cvgkp9lz0sn9j1g4ld426ksycg31xvlykk5fg7r4w";

  dontStrip = true;

  buildPhase = ''
    mix do compile --no-deps-check, elixir_ls.release
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv release $out/lib

    # Prepare the wrapper script
    substitute release/language_server.sh $out/bin/elixir-ls \
      --replace 'exec "''${dir}/launch.sh"' "exec $out/lib/launch.sh"
    chmod +x $out/bin/elixir-ls

    # prepare the launcher
    substituteInPlace $out/lib/launch.sh \
      --replace "ERL_LIBS=\"\$SCRIPTPATH:\$ERL_LIBS\"" \
                "ERL_LIBS=$out/lib:\$ERL_LIBS" \
      --replace "exec elixir" "exec ${elixir}/bin/elixir"
  '';
}
