{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = ["*"];
  };

  # Garbage collect once a week for builds older than 30 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

# TODO: set up other modules for GNOME and Sway...eventually
  # Enable the X11 windowing system.
#  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
   #services.xserver.displayManager.gdm = {
    # enable  = true;
   #};
#   services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
#  services.xserver = {
#    layout = "us";
#    xkbVariant = "";
#  };

# Sway test
  #programs.sway.enable = true;
  #security.polkit.enable = true; # Need for sway + homemanager
  #hardware.opengl.enable = true; # When using QEMU KVM which I'm pretty sure I'm not, but just in case


# TODO: See how much of this I can move to Home manager so I can keep things modular
########### HYPRLAND ##############
# Simple hyprland setup
programs.hyprland = {
  enable = true;
  package = inputs.hyprland.packages."${pkgs.system}".hyprland;
};
hardware = {
  opengl.enable = true;
  
  #Most wayland compositers need this
  nvidia.modesetting.enable = true;
};

# TODO: learn more about desktop portals
# Desktop portals - handles desktop program's interactions between each other, screen sharing, link opening, file opening, and more
xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

############ HYPRLAND ###############

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ntrinite = {
    isNormalUser = true;
    description = "me duh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  environment.shells = with pkgs; [ bash fish ];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     wget
     git # can probably get rid of this since it's defined in home-manger
     fish
     discord # might not work well with wayland
 
    # TODO: Move these to Home manager
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"];
      })
    )
    pkgs.mako # notification daemon
    libnotify #required for mako
    kitty
    networkmanagerapplet

    # app launcher
    rofi-wayland
  ];

# TODO: see if I can move this to the swaylock file or something incase I ever choose something else
  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = {
    text = "auth include login";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
