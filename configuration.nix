{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages;
    

  networking = {
    hostName = "nixos-btw";
    networkmanager.enable = true;
    hosts = {
      "192.168.18.33" = [ "raspi.casa.local" ];
      "10.129.182.29" = [
        "blog.inlanefreight.local"
        "blog-dev.inlanefreight.local"
      ];
    };
  };

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      Experimental = true;
      FastConnectable = true;
    };
    Policy = {
      AutoEnable = true;
    };
  };
};

  users.users.Tnmae = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "wireshark"
      "docker"
      "dialout"
    ];
    packages = with pkgs; [
      chromium
    ];
  };
  

  environment.systemPackages = with pkgs; [
    ffmpeg
    nvidia-vaapi-driver
    nvidia-modprobe
    neovim
    usbutils
    wget
    wl-clipboard-rs
    git
    curl
    wlogout
    discord
    obs-studio
    spotify
    lsd
    bat
    tmux
    lazygit
    fzf
    lazydocker
    wofi
    ghostty
    adw-gtk3
    papirus-icon-theme
    nh
    xfce.thunar
    gnumake
    go
    gcc
    ly
    fastfetch
    btop
    steam
    pavucontrol
    bitwarden-desktop
    docker
    docker-compose
    xdg-desktop-portal-wlr
    polkit
    nixfmt-rfc-style
    obsidian
    nmap
    openvpn
    hashcat
    burpsuite
    caido
    wireshark
    wordlists
    rockyou
    seclists
    metasploit
    gobuster
    ffuf
    sqlmap
    john
    thc-hydra
    qbittorrent
  
    xwayland
    xwayland-satellite

    nodejs
    brightnessctl
    tmux
    lua
    ripgrep
    luajitPackages.luarocks_bootstrap
    fd
    ghostscript
    mermaid-cli
    imagemagick
    tectonic
    tree-sitter
    cava
    cmatrix
    peaclock
    octave
    arduino-ide
    arduino-cli
    usbutils
    pciutils
  ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  xdg.portal.wlr.enable = true;
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
  services = {
    displayManager.enable = true;
    displayManager.ly.enable = true;
    displayManager.ly = {
      settings = {
        animation = "matrix";
        animate = true;
        bigclock = true;
      };
    };
    openssh.enable = true;
  };
  programs = {
    niri.enable = true;
    xwayland.enable = true;
    wireshark.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    gamemode.enable = true;
  };
  security.polkit.enable = true;
  virtualisation.docker.enable = true;

  environment.variables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    OZONE_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.ollama = {
      enable = true;
      acceleration = "cuda";
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";
}
