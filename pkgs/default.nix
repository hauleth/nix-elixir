final: prev: {
  beam = prev.beam // {
    packagesWith = erlang: (prev.beam.packagesWith erlang).extend (efinal: eprev: {
      livebook = eprev.callPackage ./livebook.nix { elixir = efinal.elixir_1_14; };
    });
  };

  livebook = final.beam.packages.erlang.livebook;
}
