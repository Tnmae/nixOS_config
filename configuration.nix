{ config, pkgs, lib, ... }:

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


  users = {
    users.Tnmae = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "wireshark"
        "docker"
        "dialout"
        "libvirtd"
        "kvm"
      ];
      packages = with pkgs; [
        tree
      ];
    };
  };

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
    nixos.includeAllModules = true;                                         
  };

  programs.dconf.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
  
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    ffmpeg
    nvidia-vaapi-driver
    nvidia-modprobe
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
    thunar
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
    nixfmt
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
    usbutils
    pciutils
    unzip
    qemu
    ngrok
    dnsmasq
    man-pages
    jetbrains.datagrip
    bruno
    nasm
    v4l-utils
  ];

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  xdg.portal.wlr.enable = true;
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.victor-mono
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

  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };

  programs.virt-manager.enable = true;

  hardware.nvidia-container-toolkit.enable = true;

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
    package = pkgs.ollama-cuda;
  };

  services.n8n = {
    enable = true;
    openFirewall = true;

    environment = {
      DB_TYPE = "postgresdb";
      DB_POSTGRESDB_DATABASE = "n8n";
      DB_POSTGRESDB_HOST = "localhost";
      DB_POSTGRESDB_PORT = "5432";
      DB_POSTGRESDB_USER = "n8n";

      N8N_PORT = 5678;
      N8N_HOST = "local";
      N8N_PROTOCOL = "http";
      WEBHOOK_URL = "http://localhost:5678";
      N8N_DIAGNOSTICS_ENABLED = true;
      N8N_COMMUNITY_PACKAGES_ENABLED = "true";
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    settings = {
      listen_addresses = lib.mkForce "localhost";
    };
    enableTCPIP = true;
    ensureDatabases = [ "n8n" ];
    ensureUsers = [{
      name = "n8n";
      ensureDBOwnership = true;
    }];
    authentication =  pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local all      all     trust
      # ... other auth rules ...
  
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host  all      all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };

  services.caddy = {
    enable = true;
  };

  services.tailscale = {
    enable = true;
    permitCertUid = "caddy";
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 5678 ];

  };

  system.stateVersion = "25.05";
}
