# NixOS Configs

Personal NixOS + home-manager cofngis

## Overview

| Host                             | Machine | OS    | Notes                                                                             |
| -------------------------------- | ------- | ----- | --------------------------------------------------------------------------------- |
| [`lotad`](hosts/lotad/README.md) | Main PC | NixOS | Daily Driver, AMD graphics, Gaming focused                                        |
| `poliwrath` [NOT SETUP]          | Laptop  | NixOS | Old, Chunky, Acer Predator laptop, kind of "on-the-go" but more for experimenting |

Everything custom in this repo lives under the single options namespace of **`dex`**.
`dex` = `pokedex`
(e.g. `dex.kde.enable`, `dex.discord.package`)

## Layout

```text
nixconfig/
├─ flake.nix            #inputs + outputs. Each host configuration defined here
├─ overlays/
│  └─ default.nix # single overlay Aggregator
├─ hosts/
│  ├─ common/      # Shared config between hosts
│  │  ├─ nixos.nix # system configs + home manager wiring
│  │  └─ home.nix  # home manager configs for user
│  ├─ lotad/                         # Main PC
│  │  ├─ default.nix                 # host entry with specific configurations and settings
│  │  ├─ home.nix                    # specific home manager settings/apps
│  │  ├─ configuration.nix           # specific system settings
│  │  └─ hardware-configuration.nix  # specific hardware settings
│  └─ poliwrath/      # Skeleton framework for laptop
│     ├─ default.nix
│     └─ home.nix
├─ modules/   # reusable feature modules
   ├─ nixos/  # system features
   └─ home/   # home-manager apps
```

- **`hosts/common/`** - settings every machine can have
- **`hosts/<name>/`** - per-machine settings, hardware, features, apps, etc
- **`modules/`** - features/modules defined that any host/machine can pull in and configure
  - Each should define a `dex.<feature>.enable` flag
  - Each module should be added to either `modules/nixos/default.nix` or `modules/home/default.nix`

## "Where do I put ...?"

| I want to...                                                         | Put it in...                  |
| -------------------------------------------------------------------- | ----------------------------- |
| a system setting **every** machine should have                       | `hosts/common/nixos.nix`      |
| an **optional / per-machine** system feature                         | `modules/nixos/<feature>.nix` |
| a home-manager setting the user wants on **every** machine           | `hosts/common/home.nix`       |
| an **optional / per-machine** user app or home manager configuration | `modules/nixos/<app>.nix`     |

**Example: a new optional system feature (hyprland):**
create `modules/nixos/hyprland.nix` add `dex.hyprland.enable` and other configs, add it to `modules/nixos/default.nix`, then set `dex.hyprland.enable = true;` on whichever host wants it

**Example: a new optional app (neovim):**
create `modules/home/neovim.nix` add `dex.neovim.enable` and other configs, add it to `modules/home/default.nix`, then set `dex.neovim.enable = true;` on whichever host wants it

> [!NOTE]
> Not ever app or settings are within home-manager. You can define the module using home manager but change settings within modules/nixos/ if the settings are nixos specific

## Overlays

[`overlays/default.nix`](overlays/default.nix) is the aggregator for all overlays for the whole flake.
In simple terms, an overlay is a function `final: prev: { ... }` that adds to or replaces packages in `pkgs`.

- `final`: the finished package set _after_ all overlays apply.
- `prev`: the pacakge set _before this overlay_ is applied

```nix
# Aggregator for all overlays
{ inputs }:
inputs.nixpkgs.lib.composeManyExtensions[
  # CahcyOS overlay, adds the cachyosKernels.linuxPackages-cachyos-XYZ to pkgs
  inputs.nix-cachyos-kernel.overlays.default

  # other overlays here
  (final: prev: { })
]
```

### Example of adding overlays

Create a `<package>.nix` file in `overlays/`

Patching a package:

```nix
# overlays/htop.nix

final: prev: {
  htop = prev.htop.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./htop-mytweak.patch ];
  });
}
```

Add it to the `overlays/default.nix`

```nix
{ inputs }:
inputs.nixpkgs.lib.composeManyExtensions[

  # other overlays here

  (import ./ htop.nix)

  # other overlays here

]
```

Adding a custom package

```nix
# overlays/my-package.nix

final: prev: {
  myPackage = final.writeShellScriptBin "my-package" ''
    echo "this is my package on $(hostname)"
  '';
}
```

Add it to the `overlays/default.nix`

```nix
{ inputs }:
inputs.nixpkgs.lib.composeManyExtensions[

  # other overlays here

  (import ./my-package.nix)

  # other overlays here

]
```

now you can add the package with `pkgs.my-package`

> If an overlay need `inputs` (e.g to pull a package from another flake), write
> the file as `inputs: final: prev { ... }` and import it as
> `(import ./my-overlay.nix inputs)`

The order of the `imports` can affect `prev`. Each overlay sees the previous one

### Where do I put overlay stuff?

| I want to...                                      | Do this in `overlays/default.nix`                                            |
| ------------------------------------------------- | ---------------------------------------------------------------------------- |
| add a new custom pacakge                          | `mything = final.callPackage ../pkgs/mything { };` (put derivation in pkgs/) |
| modify/patch an existing package                  | `foo = prev.foo.overrideAttrs (old: {...});`                                 |
| pull packages fom another flake                   | add its overlay to the `composeManyExtensions` list (like cachyos)           |
| pin a pacakge to a different nixpkgs (e.g stable) | add a `nixpkgs-stable` input, then `final: prev: {foo = stablePkgs.foo; }`   |

## External use-case/pulling this repo in as a flake input

Ideally this repo can be pulled in as a flake input so another repo doesn't need to pull all of this in but can still use the same modules and settings

Ex: a linux system that can still use home manager

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-conf.url = "github:ntrinite/nixos-config";
  };
  outputs = {nixpkgs, home-manager, nix-conf, ...}: {
    homeConfigurations."ntrinite@somewhere-else" =
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [nix-conf.overlays.default];
          config.allowUnfree = true;
        };
        modules = [
          nix-conf.homeManagerModules.default # can reuse the dex.<option> defined in `modules/home/`
          ./other-modules.nix
        ];
    };
  };
}

```

## TODO List:

- [ ] Update to Flake parts
