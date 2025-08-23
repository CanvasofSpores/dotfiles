# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];



  # Boot configuration. 
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 10;
      };
    };
    supportedFilesystems = [ "btrfs" ];
      # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride { mArch = "GENERIC_V3"; };
    kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "canvas" "@wheel" ];
  nix.settings.download-buffer-size = 536870912; # 512 MiB

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;
  
  hardware.graphics.enable = true;
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.65.06";
      sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
      sha256_aarch64 = "sha256-4CrNwNINSlQapQJr/dsbm0/GvGSuOwT/nLnIknAM+cQ=";
      openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
      settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
      persistencedSha256 = "sha256-ETRfj2/kPbKYX1NzE0dGr/ulMuzbICIpceXdCRDkAxA=";
    };
    videoAcceleration = true;

    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  networking = {
    hostName = "NixCanvas"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  };
  hardware.bluetooth.enable = true;

  xdg.menus.enable = true;
  xdg.mime.enable = true;
  services.udisks2.enable = true;

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };



  # Gnome Keyring
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };
  services.gnome.gnome-keyring.enable = true;


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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };



  # Hyprland/Wayland
  programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.zsh.enable = true;
  users.users.canvas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "gamemode" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [  ];
    shell = pkgs.zsh;
  };



  # File Browser
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
	      thunar-volman
	      thunar-vcs-plugin
      ];
    };
    xfconf.enable = true;
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    extraFlags = [ "--no-default-folder" ];
    user = "canvas";
    dataDir = "/home/canvas";
    configDir = "/home/canvas/.config/syncthing";
    settings = {
      options.natEnabled = true;
      gui = {
        user = "canvas";
        password = "12345";
        apikey = "4KVyZtUpSKxKWuMp4QGbAAk3p2YLjxCU";
      };
      devices = {
        "Pixel 7".id = "T6OXWXU-U3V6ZCY-O7V56NE-5XMJ5EV-IYIBO47-QXYNNGB-SLRRYB7-YNP7FQW";
      };
      folders = {
        "obsidian" = {
          label = "Obsidian Vault";
	  path = "/home/canvas/.obsidian/";
	  devices = [ "Pixel 7" ];
	};
      };
    };
  };

  catppuccin = {
    flavor = "mocha";
    accent = "mauve";
    cache.enable = true;
    grub.enable = true;
    sddm.enable = true;
    tty.enable = true;
  };


  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    kitty
    waybar
    swaybg
    swaylock
    swaylock-effects
    swaylock-fancy
    wpaperd
    wlogout
    wl-clipboard
    cliphist
    wlr-randr
    hypridle
    hyprshot
    hyprcursor
    swaynotificationcenter
    rofi-wayland
    grim
    grimblast
    slurp
    swappy
    fastfetch
    dconf
    hyprland-qtutils
    hyprland-qt-support
    hyprpolkitagent
    kdePackages.ark
    kdePackages.qtwayland
    kdePackages.plasma-integration
    kdePackages.breeze-icons
    kdePackages.qtsvg
    kdePackages.kservice
    kdePackages.qtsvg
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    kdePackages.xdg-desktop-portal-kde
    xdg-user-dirs
    xdg-utils
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    nwg-look
    udiskie
    git
    btop
    starship
    mommy
    zoxide
    fzf
    eza
    gh
    vesktop
    telegram-desktop
    bitwarden-desktop
    obsidian
    pavucontrol
    catppuccin-cursors.mochaMauve
    protonup-qt
    steam-run
    lutris
    heroic
    steamtinkerlaunch
    mangohud
    mangojuice
    (prismlauncher.override {
      jdks = [
        temurin-jre-bin-17
        temurin-jre-bin
      ];
    })
    satisfactorymodmanager
    rustup
    gcc
    unzip
    unrar
    p7zip
    unp
    oh-my-zsh
    zsh-completions
    zsh-syntax-highlighting
    zsh-history-substring-search
    xfce.gigolo
    temurin-jre-bin 
    syncthingtray
    networkmanagerapplet

  ];



  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      fira-sans
    ];
    fontDir.enable = true;
  };



  programs.command-not-found.enable = true;
  programs.firefox.enable = true;

  qt = {
    enable = true;
    style = "kvantum";
    platformTheme = "qt5ct";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };



  #Gaming
  programs.gamemode = {
    enable = true; # for performance mode
    settings.general.inhibit_screensaver = 0;
  };
  programs.steam = {
    enable = true; # install steam
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

