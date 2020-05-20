{ stdenvNoCC, elixir, hex, rebar, rebar3, git, cacert }:

let
  fetchMixDeps =
    { name ? "mix", src, sha256, mixEnv ? "prod" }:
    stdenvNoCC.mkDerivation {
      name = "${name}-deps";

      nativeBuildInputs = [ elixir hex git cacert ];

      inherit src;

      MIX_ENV = mixEnv;
      MIX_REBAR = "${rebar}/bin/rebar";
      MIX_REBAR3 = "${rebar3}/bin/rebar3";

      configurePhase = ''
        export HEX_HOME="$TMPDIR/hex"
        export MIX_HOME="$TMPDIR/mix"
        export REBAR_GLOBAL_CONFIG_DIR="$TMPDIR/rebar3"
        export REBAR_CACHE_DIR="$TMPDIR/rebar3.cache"

        export MIX_DEPS_PATH="$out"
      '';

      buildPhase = ''
        mix deps.get
        find "$out" -path '*/.git/*' -a ! -name HEAD -exec rm -rf {} +
      '';

      dontInstall = true;

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = sha256;

      impureEnvVars = stdenvNoCC.lib.fetchers.proxyImpureEnvVars;
    };
in fetchMixDeps
