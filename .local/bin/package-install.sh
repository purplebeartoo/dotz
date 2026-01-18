#!/usr/bin/env bash
# New installation package install

set -euo pipefail

# Install pacman packages
echo "Installing Pacman packages..."
sudo pacman -S age apparmor bat btop chromium cmus cronie dconf-editor dunst eza fastfetch fd ffmpeg firefox flatpak fuzzel fzf galculator gcr git gnome-themes-extra grim gvfs handlr imagemagick imv kitty kvantum libmad libva-mesa-driver libzip linux-headers luarocks man-db meld mesa nemo neovim noto-fonts noto-fonts-emoji otf-font-awesome pam-u2f pavucontrol playerctl podman polkit-gnome poppler python-pillow qt5-wayland qt6-wayland reflector ripgrep rocm-smi-lib rsync sbctl slirp4netns slurp starship timeshift ttf-cascadia-code-nerd ttf-dejavu ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono tumbler ufw unzip usbguard usbutils vulkan-radeon waybar wget wl-clipboard xdg-user-dirs yazi zip zoxide zsh zsh-autosuggestions zsh-syntax-highlighting || {
  echo "Pacman packages failed to install."
  exit 1
}

 # Uncomment for Hyprland stable install
 # echo "Installing Hyprland packages..."
 # sudo pacman -S hypridle hyprland hyprlang hyprlock hyprpaper xdg-desktop-portal-hyprland || {
 #   echo "Hyprland repo packages failed to install."
 #   exit 1
 # }

# Flatpak setup and installation
echo "Adding Flathub flatpak repository..."
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo || {
  echo "Error: Failed to add Flatpak repository. Check your internet connection."
  exit 1
}

echo "Installing flatpak applications..."
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

# Create default user directories
echo "Creating user directories"
 xdg-user-dirs-update || {
  echo "Failed to create default user directories."
  exit 1
}

echo "Pacman and flatpak installations complete."

# Check if yay is available
if ! command -v yay &> /dev/null; then
  echo "Error: Yay not found. Please install yay first."
  exit 1
fi

# Install AUR packages
echo "Installing AUR packages..."
yay -S bubblejail gtk-engine-murrine rose-pine-cursor rose-pine-hyprcursor tokyonight-gtk-theme-git waybar-module-pacman-updates-git || {
  echo "Error: Failed to install AUR packages. Check yay logs."
  exit 1
}

echo "Package installations complete."
