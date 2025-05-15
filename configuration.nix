# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./system/network.nix
    ./system/file_system.nix
    ./system/locale.nix
    ./system/audio.nix
    ./remaps.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [
      "nvidia_uvm" # obs fix
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.keyboard.qmk.enable = true;

  # Enable graphics with nvidia drivers
  # Enable OpenGL
  hardware.graphics = { enable = true; };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hirw = {
    isNormalUser = true;
    description = "Ross Williamson";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.user = "hirw";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    coreutils
    man-pages
    vim
    wayland
    grim
    slurp # snipping tool thing
    hyprshot
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    git
    openssh
    gcc
    clang_19
    clang-tools
    python314
    nodejs_22
    elixir
    erlang
    ruby
    rustup
    cmake
    ripgrep
    unzip
    qimgv
    wofi
    playerctl
    waybar
    dunst
    zsh
    inotify-tools
    rtkit
    via
    fd
    file-roller
    SDL2
    ffmpeg
    pkg-config
    fontconfig
    linux-firmware
    hyprpaper
    hyprpolkitagent
  ];

  programs = {
    nm-applet.enable = true; # Network manager applet
    firefox.enable = true;
    xfconf.enable = true; # For configuring thunar settings
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin ];
    };
    zsh.enable = true;
    steam.enable = true;
    hyprland.enable = true;
  };

  # Services
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        # command = "${pkgs.sway}/bin/sway --unsupported-gpu";
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "hirw";
      };
      default_session = initial_session;
    };
  };

  services.udev.packages = [ pkgs.via ];

  # required for certain thunar functionality
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thunar thumbnails

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "hirw" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type  database  DBuser  address       auth-method
      local  all       all                   trust
      host   all       all     127.0.0.1/32  trust
      host   all       all     ::1/128       trust
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
