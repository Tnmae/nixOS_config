uses
niri as a scrollable tiling wayland compositor
ly as a login manager (with matrix animation enabled)
wofi as application launcher
chromium as browser
swww for displaying wallpapers
ghostty terminal
waybar
home-manager from nixos repository

to use this github repository, firstly
copy your system's hardware configuration using
cp /etc/nixos/hardware-configuration.nix ~/nixOS_config/

then run this command
sudo nixos-rebuild switch --flake ~/nixOS_config#Tnmae
then reboot into your system

for setting wallpaper run
swww img /path/to/the/imgORgif
