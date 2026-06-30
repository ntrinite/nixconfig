# Aggregator for all overlays
{ inputs }:
inputs.nixpkgs.lib.composeManyExtensions [
  # CahcyOS overlay, adds the cachyosKernels.linuxPackages-cachyos-XYZ to pkgs
  inputs.nix-cachyos-kernel.overlays.pinned
  inputs.nix-vscode-extensions.overlays.default

  # other overlays here
  # mything = final.callPackage ../pkgs/mything { };
  (final: prev: { })
]
