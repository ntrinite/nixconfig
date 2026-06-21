{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dex.fish;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkIf;
in
{
  options.dex.fish = {
    enable = mkEnableOption "enable fish shell";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      # Aliases are defined as home.shellAliases
      # Common abbrv and functions
      # TODO: look into maybe having an "extraAbbrs" and "extraFunc" options
      # For now, additional shellAbbrv and functions will need to be defined in
      # hosts/<hostname>/home.nix as something like
      # programs.fish.shellAbbrv = { xyz = abc; };
      shellAbbrs = {
        gc = "git commit -m";
        gp = "git push";
        gpo = "git push -u origin";
        nd = "nix develop";
        nb = "nix build";
        nfu = "nix flake update";
        nfl = "nix flake lock --update-input";
      };
      functions = {
        deg2rad = {
          body = ''math $argv[1] "*" \(3.1415926535897932384626433832795 / 180.0\)'';
          wraps = "math";
        };
        rad2deg = {
          body = ''math $argv[1] "*" \(180.0 / 3.1415926535897932384626433832795\)'';
          wraps = "math";
        };
        ft2m = {
          body = ''math $argv[1] "*" 0.3048'';
          wraps = "math";
        };
        mft = {
          body = "math $argv[1] / 0.3048";
          wraps = "math";
        };
        ms2knts = {
          body = ''math $argv[1] "*" 1.94384449244'';
          wraps = "math";
        };
        knts2ms = {
          body = "math $argv[1] / 1.94384449244";
          wraps = "math";
        };
        mph2ms = {
          body = "math $argv[1] / 2.23694";
          wraps = "math";
        };
        ms2mph = {
          body = ''math $argv[1] "*" 2.23694'';
          wraps = "math";
        };
      };
      plugins = [
        {
          # Makes fish work better in nix environments,
          # NOTE: kidonng did this originally but there is a PR (https://github.com/kidonng/nix.fish/pull/2)
          # that has a small fix that hasn't been touched in a while
          name = "nix.fish";
          src = pkgs.fetchFromGitHub {
            #owner = "kidonng";
            owner = "Animeshz";
            repo = "nix.fish";
            # rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
            rev = "a3256cf49846ee4de072c3a9af7a58aad4021693";
            hash = "sha256-3M0dU30SrdjInp6MWEC0q7MTInrZNtY6Z9mhBw43PKs=";
          };
        }
      ];
      interactiveShellInit = ''
        ${lib.optionalString config.dex.pokefetch.enable ''
          pokefetch
        ''}
      '';
    };

  };

}
