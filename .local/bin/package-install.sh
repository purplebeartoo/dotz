#!/usr/bin/env bash
# Package install

# Strict bash execution mode
set -euo pipefail

# Pacman install
echo "Installing Pacman packages..."
sudo pacman -S age apparmor bat btop chromium cmus cronie dconf-editor dunst eza fastfetch fd ffmpeg flatpak fuzzel fzf galculator gcr git grim gvfs handlr imagemagick imv keepassxc kitty kvantum libmad libva-mesa-driver libzip linux-headers luarocks man-db meld mesa nemo neovim noto-fonts noto-fonts-emoji otf-font-awesome pam-u2f pavucontrol pciutils playerctl podman polkit-gnome poppler python-pillow qt5-wayland qt6-wayland reflector ripgrep rocm-smi-lib rsync slirp4netns slurp starship timeshift ttf-cascadia-code-nerd ttf-dejavu ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono tumbler ufw unzip usbguard usbutils vulkan-radeon waybar wget wl-clipboard xdg-user-dirs yazi zip zoxide zsh zsh-autosuggestions zsh-syntax-highlighting || {
  echo "Pacman packages failed to install."
  exit 1
}

# # Hyprland repo install
# echo "Installing Pacman packages..."
# sudo pacman -S hypridle hyprland hyprlang hyprlock hyprpaper xdg-desktop-portal-hyprland || {
#   echo "Hyprland repo packages failed to install."
#   exit 1
# }

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
flatpak install -y --user --noninteractive flathub org.gimp.GIMP.Plugin.GMic || {
  echo "Error: Failed to install org.gimp.GIMP.Plugin.GMic."
  exit 1
}
flatpak install -y --user --noninteractive flathub org.gnome.Papers || {
  echo "Error: Failed to install org.gnome.Papers."
  exit 1
}
echo "Flatpak installations complete."

# AUR install
echo "Installing AUR packages..."
paru -S brave-bin bubblejail kvantum-theme-gruvbox-git otf-apple-fonts rose-pine-cursor gruvbox-dark-icons-gtk gruvbox-material-gtk-theme-git rose-pine-hyprcursor waybar-module-pacman-updates-git || {
  echo "Error: Failed to install AUR packages. Check Paru logs."
  exit 1
}

# Hyprland AUR package install
echo "Installing Hyprland AUR packages..."
paru -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils-git hypridle-git hyprlock-git hyprpaper-git xdg-desktop-portal-hyprland-git || {
  echo "Error: Failed to install Hyprland AUR packages. Check Paru logs."
  exit 1
}

echo "Host package installation complete."
