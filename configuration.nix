# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.xremap-flake.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  fileSystems."/mnt/HDD" = {
    device = "/dev/disk/by-uuid/01D8BA822599C960";
    fsType = "ntfs";
    options = [
      "users" # Anyone can mount tha HDD!!!!!!
      "nofail" # No biggie if we cant mount it <:-D
    ];
  };

  fileSystems."/mnt/SSD2" = {
    device = "/dev/disk/by-uuid/01DAEB9EA9367710";
    fsType = "ntfs";
    options = [
      "users" # Anyone can mount tha HDD!!!!!!
      "nofail" # No biggie if we cant mount it <:-D
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.

  # nix-shell -p pavucontrol -> playback
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    extraConfig.pipewire = {
      # Helps prevent buffer underrun causing stuttering
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 128;
        "default.clock.max-quantum" = 1024;
      };
    };
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable graphics with nvidia drivers
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  
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
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.user = "hirw";

  services.xremap = {
    withHypr = true;
    userName = "hirw";
    config = {
      keymap = [
        {
          name = "General Remaps";
          remap = {
            "CapsLock" = "Esc";
          };
        }
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wayland
    grim
    slurp # snipping tool thing
    hyprshot
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    git
    openssh
    gcc
    python314
    nodejs_22
    ripgrep
    unzip
    qimgv # image previewing
    wofi
    playerctl
    waybar
    pavucontrol
    dunst
    zsh
    inotify-tools
  ];

  programs.nm-applet.enable = true; # Network manager applet
  programs.firefox.enable = true;
  programs.xfconf.enable = true; # For configuring thunar settings
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };
  programs.zsh.enable = true;
  programs.hyprland.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
