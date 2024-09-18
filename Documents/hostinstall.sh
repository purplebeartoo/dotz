#!/bin/bash    
# hostinstall

# core
sudo pacman -S age alsa-utils apparmor base-devel bat brightnessctl btop cmus cronie dconf-editor dunst eza fastfetch fd ffmpeg firefox firejail flatpak fuzzel fzf galculator gcr git grim gvfs handlr hypridle hyprlang hyprlock hyprpaper imagemagick imv inotify-tools keepassxc kitty kvantum kvantum-qt5 libva-mesa-driver libzip linux-headers logrotate luarocks man-db meld mesa nemo neovim nm-connection-editor noto-fonts noto-fonts-emoji pam-u2f pavucontrol pciutils perl-image-exiftool playerctl polkit-gnome python-pillow qt5-wayland qt6-wayland reflector ripgrep rsync slurp starship timeshift ttf-dejavu ttf-jetbrains-mono tumbler ufw unzip usbguard usbutils vulkan-radeon waybar wl-clipboard xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-user-dirs xf86-video-amdgpu yazi zip zsh zsh-autosuggestions zsh-syntax-highlighting
echo "Pacman packages installed."

# flatpaks
# flatpak install -y --user --noninteractive flathub io.gitlab.adhami3310.Impression
# flatpak install -y --user --noninteractive flathub flathub org.gimp.GIMP
# flatpak install -y --user --noninteractive flathub flathub org.gimp.GIMP.Plugin.GMic
flatpak install -y --user --noninteractive flathub com.github.tchx84.Flatseal
flatpak install -y --user --noninteractive flathub flathub io.mpv.Mpv
flatpak install -y --user --noninteractive flathub flathub org.gnome.Evince
flatpak install -y --user --noninteractive flathub-beta org.gimp.GIMP
flatpak install -y --user --noninteractive flathub-beta org.gimp.GIMP.Plugin.GMic
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
echo "Flatpak installations complete."

# Hyprland from source
# paru -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang hyprcursor hyprwayland-scanner-git xcb-util-errors hyprutils-git aquamarine-git 
# git clone --recursive https://github.com/hyprwm/Hyprland
# cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DNO_XWAYLAND:STRING=true -B build -G Ninja
# cmake --build ./build --config Release --target all
# sudo cmake --install ./build
