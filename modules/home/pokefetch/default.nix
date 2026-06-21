{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dex.pokefetch;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib) mkIf;
  inherit (lib.types)
    listOf
    str
    package
    int
    ;

  pokefetchScript = pkgs.writeShellApplication {
    name = "pokefetch";
    runtimeInputs = with pkgs; [
      cfg.fetcherPackage
      pokeget-rs
      coreutils
      gnused # sed
      gawk # awk
    ];

    # The script references $FETCHER, $POKEMON_LIST, etc. before they're "declared"
    # to shellcheck, and uses word-splitting on POKEMON_LIST entries by design.
    excludeShellChecks = [
      "SC2004"
      "SC2086"
      "SC2154"
      "SC2206"
    ];
    text = ''
      POKEMON_LIST=(${
        lib.concatMapStringsSep "\n" (p: " ${lib.escapeShellArg p}") (
          if cfg.pokemonList == [ ] then [ "random" ] else cfg.pokemonList
        )
      })
      FETCHER=${lib.escapeShellArg cfg.fetcher}
      EXTRA_PADDING_H=${toString cfg.extraPaddingH}
      EXTRA_PADDING_W=${toString cfg.extraPaddingW}
      WIDTH=${toString cfg.width}
    ''
    + builtins.readFile ./pokefetch.sh;
  };
in
{
  options.dex.pokefetch = {
    enable = mkEnableOption "enable pokefetch";
    pokemonList = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Pokemon to choose from at ranom. Each entry is passed to pokeget
        so flags like -s (shiny) or --mega-y may be appended. See
        pokeget for the full list of supported names and forms

        Set to empty list to get random pokemon each time
      '';
      example = [
        "pikachu"
        "eevee -s"
        "charizard --mega-y"
      ];
    };
    fetcher = mkOption {
      type = str;
      default = "fastfetch --logo none";
      description = ''
        The system-info fetcher command. So far only fastfetch is supported
        but this _should_ allow us to override it with a different fetcher
      '';
    };
    fetcherPackage = mkOption {
      type = package;
      default = pkgs.fastfetch;
    };
    extraPaddingH = mkOption {
      type = int;
      default = 2;
      description = ''
        Extra rows added on top of the auto centering padding. The base top
        padding is computed per-sprite as `(fastfetch_height - sprite_height) / 2`
        to vertically center the sprite then the `extraPaddingH` is added on top of that
      '';
    };
    extraPaddingW = mkOption {
      type = int;
      default = 0;
      description = ''
        Extra rows added on top of the auto centering padding. The base top
        padding is computed per-sprite as `(cfg.dex.pokefetch.width - sprite_width) / 2`
        to horizontally center the sprite then the `extraPaddingW` is added on top of that
      '';
    };

    width = mkOption {
      type = int;
      default = 38;
      description = "Maximum sprite display width to center sprite horizontally";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pokefetchScript
    ];
  };

}
