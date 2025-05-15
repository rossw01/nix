{ config, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
    overlays = [ (import ./overlays/vlc.nix) (import ./overlays/discord.nix) ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "hirw";
  home.homeDirectory = "/home/hirw";

  home.sessionVariables = {
    PIPEWIRE_DEBUG = 4;
    PW_LOG_LEVEL = 4;
    EDITOR = "nvim";
    NIX_CONF = "$HOME/.config/nix";
    NVIM_CONF = "$HOME/.config/nvim";
    NIXOS_OZONE_WL = 1;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "IosevkaTerm" "Lilex" ]; })
    kitty
    discord
    lutris
    gpu-screen-recorder-gtk
    wine
    via
    tiled
    nicotine-plus
    obs-studio
    vlc
    zathura
    lua
    lua52Packages.luarocks

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "colored-man-pages" ];
    };
    shellAliases = {
      nfc = "$EDITOR $NIX_CONF";
      nvc = "$EDITOR $NVIM_CONF";
    };
    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./dots/p10k-config;
        file = ".p10k.zsh";
      }
    ];
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [ lua52Packages.lua-lsp ];
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.doom ];
  };
}
