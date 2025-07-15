#!/bin/bash    
# Host install

# Pacman
# hypridle hyprland hyprlang hyprlock hyprpaper xdg-desktop-portal-hyprland
sudo pacman -S age alsa-utils apparmor base-devel bat brightnessctl btop cmus cronie dconf-editor dunst eza fastfetch fd ffmpeg flatpak fuzzel fzf galculator gcr ghostty git grim gvfs handlr imagemagick inotify-tools keepassxc kvantum kvantum-qt5 libva-mesa-driver libzip linux-headers logrotate luarocks man-db meld mesa nemo neovim nm-connection-editor noto-fonts noto-fonts-emoji pam-u2f pavucontrol pciutils playerctl podman polkit-gnome python-pillow qt5-wayland qt6-wayland reflector ripgrep rocminfo rsync slirp4netns slurp starship tela-circle-icon-theme-dracula timeshift ttf-cascadia-code-nerd ttf-dejavu ttf-font-awesome ttf-nerd-fonts-symbols-mono tumbler ufw unzip usbguard usbutils vimiv vulkan-radeon waybar wl-clipboard xdg-user-dirs xf86-video-amdgpu zip zsh zsh-autosuggestions zsh-syntax-highlighting
echo "Pacman packages installed."

# Flatpaks
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# flatpak install -y --user --noninteractive flathub com.github.paolostivanin.OTPClient
# flatpak install -y --user --noninteractive flathub io.gitlab.adhami3310.Impression
flatpak install -y --user --noninteractive flathub com.github.tchx84.Flatseal
flatpak install -y --user --noninteractive flathub io.mpv.Mpv
flatpak install -y --user --noninteractive flathub org.gimp.GIMP
flatpak install -y --user --noninteractive flathub org.gimp.GIMP.Plugin.GMic
flatpak install -y --user --noninteractive flathub org.gnome.Papers

echo "Flatpak installations complete."

# AUR
paru -S brave-bin bubblejail chromium dracula-gtk-theme otf-apple-fonts rose-pine-cursor rose-pine-hyprcursor waybar-module-pacman-updates-git yazi-git

# Rebuild git packages
# paru -Syu --rebuild --rebuild=all hyprlang-git hyprcursor-git hyprwayland-scanner-git hyprutils-git hyprgraphics-git aquamarine-git hyprland-qtutils-git hypridle-git hyprlock-git hyprpaper-git xdg-desktop-portal-hyprland-git

# Hyprland from source
# paru -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils-git hypridle-git hyprlock-git hyprpaper-git xdg-desktop-portal-hyprland-git
# git clone --recursive https://github.com/hyprwm/Hyprland
# cd Hyprland
# cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DNO_XWAYLAND:STRING=true -DNO_UWSM:STRING=true -DNO_HYPRPM:STRING=true -B build -G Ninja
# cmake --build ./build --config Release --target all
# sudo cmake --install ./build
