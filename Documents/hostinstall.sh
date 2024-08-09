#!/bin/bash    
#hostinstall

#core
sudo pacman -S age alsa-utils apparmor base-devel bat brightnessctl btop cmus cronie dconf-editor dunst eza fastfetch fd ffmpeg firefox firejail flatpak foot fuzzel fzf galculator gcr git grim gvfs handlr hypridle hyprlang hyprlock hyprpaper imv inotify-tools keepassxc kvantum kvantum-qt5 libva-mesa-driver libzip linux-headers logrotate man-db meld mesa nemo neovim nm-connection-editor noto-fonts noto-fonts-emoji pam-u2f pavucontrol pciutils perl-image-exiftool playerctl polkit-gnome qt5-wayland qt6-wayland ranger reflector ripgrep rsync slurp starship timeshift ttf-dejavu ttf-jetbrains-mono-nerd tumbler ufw unzip usbguard usbutils vulkan-radeon waybar wireguard-tools wl-clipboard xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-user-dirs xf86-video-amdgpu zip zsh zsh-autosuggestions zsh-syntax-highlighting
echo "Pacman packages installed."

#flatpaks
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
#flatpak install -y --user --noninteractive flathub flathub org.gimp.GIMP
#flatpak install -y --user --noninteractive flathub flathub org.gimp.GIMP.Plugin.GMic
flatpak install -y --user --noninteractive flathub com.github.tchx84.Flatseal
flatpak install -y --user --noninteractive flathub flathub org.gnome.Evince
# flatpak install -y --user --noninteractive flathub io.gitlab.adhami3310.Impression
flatpak install -y --user --noninteractive flathub io.mpv.Mpv
flatpak install -y --user --noninteractive flathub-beta org.gimp.GIMP
flatpak install -y --user --noninteractive flathub-beta org.gimp.GIMP.Plugin.GMic
echo "Flatpak installations complete."

#Hyprland from source
#paru -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang hyprcursor hyprwayland-scanner xcb-util-errors hyprutils-git
