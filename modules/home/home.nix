{ config, pkgs, nvf, ... }:

{
  home.username = "Tnmae";
  home.homeDirectory = "/home/Tnmae";
  home.stateVersion = "25.05";
  
  imports = [
    ./waybar/waybar.nix
    ./niri/niri.nix
    ./bash.nix
    ./wofi/wofi.nix
    ./tmux.nix
    ./ghostty.nix
  ];

  ########################################
  # 🧰 User tools and base config
  ########################################
  home.packages = with pkgs; [
    nixpkgs-fmt
    nil
    fastfetch
    btop
    starship
    swaynotificationcenter
    waybar-mpris
    playerctl
    waypaper
    waybar
    swaylock
    swww
  ];

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";

    colorScheme = "dark";
  };
  qt = {
    style.name = "adwaita-dark";
  };
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.mochaSapphire;
    name = "catppuccin-mocha-sapphire-cursors";
    size = 12;
  };

  ########################################
  # 🧬 Git config
  ########################################
  programs = {
    bash.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    obs-studio.enable = true;
    obs-studio.plugins = [ pkgs.obs-studio-plugins.wlrobs ];
    git = {
      enable = true;
      settings = {
        user = {
          name = "Tnmae";
          email = "ttyagi.2505@gmail.com";
        };
      };
      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
        color.ui = "auto";
      };
    };
  };

  services.swww.enable = true;
  services.swaync.enable = true;

}
