#!/usr/bin/env bash
# Package install

# Strict bash execution mode
set -euo pipefail

# Pacman install
echo "Installing Pacman packages..."
sudo pacman -S age alsa-utils apparmor base-devel bat brightnessctl btop chromium cmus cronie dconf-editor dunst eza fastfetch fd ffmpeg flatpak fuzzel fzf galculator gcr ghostty git grim gvfs handlr imagemagick inotify-tools keepassxc kvantum kvantum-qt5 libva-mesa-driver libzip linux-headers logrotate luarocks man-db meld mesa nemo neovim nm-connection-editor noto-fonts noto-fonts-emoji otf-font-awesome pam-u2f pavucontrol pciutils playerctl podman polkit-gnome poppler python-pillow qt5-wayland qt6-wayland reflector ripgrep rocm-smi-lib rocminfo rsync slirp4netns slurp starship tela-circle-icon-theme-dracula timeshift ttf-cascadia-code-nerd ttf-dejavu ttf-nerd-fonts-symbols-mono tumbler ufw unzip usbguard usbutils vimiv vulkan-radeon waybar wget wl-clipboard xdg-user-dirs xf86-video-amdgpu zip zsh zsh-autosuggestions zsh-syntax-highlighting || {
  echo "Pacman packages failed to install."
  exit 1
}

# Flatpak setup
echo "Adding Flatpak repository..."
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo || {
  echo "Error: Failed to add Flatpak repository. Check your internet connection."
  exit 1
}

echo "Installing Flatpak applications..."
flatpak install -y --user --noninteractive flathub com.github.tchx84.Flatseal || {
  echo "Error: Failed to install com.github.tchx84.Flatseal."
  exit 1
}
flatpak install -y --user --noninteractive flathub io.mpv.Mpv || {
  echo "Error: Failed to install io.mpv.Mpv."
  exit 1
}
flatpak install -y --user --noninteractive flathub org.gimp.GIMP || {
  echo "Error: Failed to install org.gimp.GIMP."
  exit 1
}
flatpak install -y --user --noninteractive flathub org.gnome.Papers || {
  echo "Error: Failed to install org.gnome.Papers."
  exit 1
}
echo "Flatpak installations complete."

# AUR install
echo "Installing AUR packages..."
paru -S brave-bin bubblejail dracula-gtk-theme otf-apple-fonts rose-pine-cursor rose-pine-hyprcursor waybar-module-pacman-updates-git yazi-git || {
  echo "Error: Failed to install AUR packages. Check Paru logs."
  exit 1
}

# Hyprland AUR package install
echo "Installing Hyprland AUR packages..."
paru -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils-git hypridle-git hyprlock-git hyprpaper-git xdg-desktop-portal-hyprland-git || {
  echo "Error: Failed to install Hyprland AUR packages. Check Paru logs."
  exit 1
}

echo "Host package installation complete."
