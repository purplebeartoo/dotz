#!/bin/bash    
#hostinstall

#core
sudo pacman -S alacritty alsa-utils apparmor arch-audit base-devel bat btop cmus compsize cronie dconf-editor duf dunst eza fd ffmpeg firejail flatpak fuzzel fzf galculator gawk git gnome-disk-utility gparted grim gvfs handlr hyprland hyprlang hyprpaper imv inotify-tools keepassxc kvantum kvantum-qt5 libva-mesa-driver linux-headers logrotate man-db meld mesa ncurses nemo neovim nm-connection-editor noto-fonts noto-fonts-emoji pam-u2f pavucontrol perl-image-exiftool playerctl polkit-gnome qt5-wayland qt6-wayland radeontop ranger reflector ripgrep rsync slurp starship swayidle timeshift ttf-dejavu ttf-firacode-nerd ttf-liberation ttf-opensans tumbler ufw unzip vulkan-radeon waybar wl-clipboard xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-user-dirs xf86-video-amdgpu zip zsh zsh-autosuggestions zsh-syntax-highlighting
echo "Pacman packages installed."

#flatpaks
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
#flatpak install -y --user --noninteractive flathub flathub org.gimp.GIMP
#flatpak install -y --user --noninteractive flathub flathub org.gimp.GIMP.Plugin.GMic
flatpak install -y --user --noninteractive flathub com.github.tchx84.Flatseal
flatpak install -y --user --noninteractive flathub flathub org.gnome.Evince
flatpak install -y --user --noninteractive flathub flathub org.mozilla.firefox
# flatpak install -y --user --noninteractive flathub io.gitlab.adhami3310.Impression
flatpak install -y --user --noninteractive flathub io.mpv.Mpv
flatpak install -y --user --noninteractive flathub-beta org.gimp.GIMP
#flatpak install -y --user --noninteractive flathub-beta org.gimp.GIMP.Plugin.GMic
echo "Flatpak installations complete."

#Hyprland from source
#paru -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus
