# Shared system configuration imported by EVERY host (see hosts/<name>/default.nix)
#
# This file also wires hoe-manager into NixOS one, so
# individual hosts never import the HM module themselves.
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../modules/nixos # makes "dex.*" config options available to every host
  ];

  # Locale / Time
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # networking
  networking.networkmanager.enable = true;

  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Just have the same user across all machines for now
  # Will change when needing multi-users or a different user all together
  users.users.ntrinite = {
    isNormalUser = true;
    description = "ntrinite";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Bare systemPackages without configurations rn
  environment.systemPackages = with pkgs; [
    vim
    git
    nil # nix language server
    nixfmt # nix formatter
  ];

  # Home Manager
  # Once for all hosts
  # Kind of goes against the user thing but it works for ow
  # `home-manager.users.ntrinite = import ./home.nix` in host's default.nix
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    # HM Modules every user gets
    sharedModules = [
      ../../modules/home
      ./home.nix
    ];
  };
}
