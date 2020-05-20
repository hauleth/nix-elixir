{ stdenv, elixir, hex, rebar, rebar3, fetchMixDeps }:

{ name ? "${args.pname}-${args.version}"
, mixSha256 ? null
, src ? null
, sourceRoot ? null
, buildInputs ? []
, nativeBuildInputs ? []
, buildType ? "release"
, meta ? {}
, mixEnv ? "prod"
, ... } @ args:

let
  mixDeps = fetchMixDeps {
    inherit src name mixEnv;
    sha256 = mixSha256;
  };
in stdenv.mkDerivation (args // {
  dontStrip = true;

  nativeBuildInputs = nativeBuildInputs ++ [ hex elixir ];

  MIX_ENV = mixEnv;
  HEX_OFFLINE = 1;
  MIX_REBAR = "${rebar}/bin/rebar";
  MIX_REBAR3 = "${rebar3}/bin/rebar3";

  postUnpack = ''
    runHook preConfigure

    export HEX_HOME="$TMPDIR/hex"
    export MIX_HOME="$TMPDIR/mix"
    export REBAR_GLOBAL_CONFIG_DIR="$TMPDIR/rebar"
    export REBAR_CACHE_DIR="$TMPDIR/rebar-cache"
    export MIX_DEPS_PATH="$TMPDIR/deps"

    cp --no-preserve=all -R "${mixDeps}" "$MIX_DEPS_PATH"

    runHook postConfigure
  '' + (args.postUnpack or "");

  configurePhase = args.configurePhase or ''
    runHook preConfigure

    mix deps.compile --no-deps-check --skip-umbrella-children

    runHook postConfigure
  '';

  buildPhase = args.buildPhase or ''
    runHook preBuild

    mix do compile --no-deps-check, release --path "$out"

    runHook postBuild
  '';

  installPhase = args.installPhase or ''
    runHook preInstall
    runHook postInstall
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck
    echo "Running mix test ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    mix test ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
    runHook postCheck
  '';
})
