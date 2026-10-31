#!/bin/sh

packages=$(cat << EOF
void-repo-nonfree
connman
dbus
polkit
pipewire
alsa-pipewire
alsa-utils
sof-firmware
mesa-dri
vulkan-loader
mesa-vulkan-intel
intel-video-accel
dumb_runtime_dir
libinput
libxkbcommon
wayland
wlroots0.20
xorg-server-xwayland
base-devel
opendoas
seatd
chrony
socklog-void
udisks2
bash-completion
dejavu-fonts-ttf
gsettings-desktop-schemas
xdg-desktop-portal
xdg-desktop-portal-wlr
gnome-themes-extra
wl-clipboard
xdg-user-dirs
foot
wmenu
brightnessctl
ufw
neovim
tmux
grim
slurp
imv
mpv
mako
libnotify
playerctl
mpd
mpdris2-rs
ncmpcpp
EOF
)

xbps-install -Sy $packages
xbps-install -Sy intel-ucode

rm /var/service/dhcpcd
rm /var/service/wpa_supplicant

services=$(cat << EOF
connmand
dbus
seatd
polkitd
chronyd
socklog-unix
nanoklogd
ufw
EOF
)

for service in $services; do
    ln -s "/etc/sv/$service" /var/service/
done

mkdir -p /etc/pipewire/pipewire.conf.d
mkdir -p /etc/alsa/conf.d
ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/
ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/

rm /etc/fonts/conf.d/10-sub-pixel-none.conf
ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/

cat > /etc/xbps.d/ignore.conf << EOF
ignorepkg=sudo
ignorepkg=nvi
ignorepkg=linux-firmware-amd
ignorepkg=linux-firmware-nvidia
EOF

cat > /etc/doas.conf << EOF
permit persist :wheel
permit nopass :wheel cmd poweroff
permit nopass :wheel cmd reboot
permit nopass :wheel cmd zzz
permit nopass :wheel cmd xbps-install args -Su
permit nopass :wheel cmd xbps-remove args -Oo
EOF

ufw enable
xbps-remove -Ry sudo nvi linux-firmware-amd linux-firmware-nvidia
xbps-reconfigure -f fontconfig "linux$(uname -r | cut -d '.' -f 1-2)"
usermod -aG _seatd,socklog $(grep "wheel" /etc/group | cut -d ":" -f 4)
