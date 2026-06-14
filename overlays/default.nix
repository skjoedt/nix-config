{ inputs }:

[
  # temp fix for https://github.com/nixos/nixpkgs/issues/476794
  (final: prev: {
    nix = prev.nix.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  })
  inputs.hermes-agent.overlays.default
]
