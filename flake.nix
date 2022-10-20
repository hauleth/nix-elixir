{
  description = "Simple Nixpkgs overlay for building Mix releases";

  outputs = { self }: {
    overlays.default = import ./.;
  };
}
