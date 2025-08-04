#!/usr/bin/env bash
# User write config

# Strict bash execution mode
set -euo pipefail

# Trap any unexpected errors and print a message
trap 'echo "Error occurred on line $LINENO" >&2; exit 1' ERR

# Write theme and icon settings
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula-dark' || {
  echo "Failed to set icon theme 'Tela-circle-dracula-dark'" >&2
  exit 1
}
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula' || {
  echo "Failed to set GTK theme 'Dracula'" >&2
  exit 1
}

# Sync settings from a backup
rsync -a "$HOME"/Downloads/.local/share/bubblejail "$HOME"/.local/share || {
  echo "Failed to sync bubblejail directory" >&2
  exit 1
}
rsync -a "$HOME"/Downloads/.config/cmus/playlists "$HOME"/.config/cmus || {
  echo "Failed to sync cmus playlists" >&2
  exit 1
}
rsync -a "$HOME"/Downloads/.config/{BraveSoftware,chromium,Kvantum,nextdns} "$HOME"/.config || {
  echo "Failed to sync .config directories" >&2
  exit 1
}
rsync -a "$HOME"/Downloads/{.ssh,BrowserProfiles,Packages,Pictures,Playlists,Videos} "$HOME" || {
  echo "Failed to sync user directories" >&2
  exit 1
}
rsync -a --exclude 'linuxnotes.txt' "$HOME"/Downloads/Documents "$HOME" || {
  echo "Failed to sync Documents directory" >&2
  exit 1
}

# Build bat cache
bat cache --build || {
  echo "Failed to build bat cache" >&2
  exit 1
}

# Install Yazi Dracula flavor
ya pkg add yazi-rs/flavors:dracula || {
  echo "Failed to install package 'yazi-rs/flavors:dracula'" >&2
  exit 1
}

# Install Yatline and theme
echo "Install Yatline from GitHub..."
git clone https://github.com/imsi32/yatline.yazi.git ~/.config/yazi/plugins/yatline.yazi || {
  echo "Error: Failed to clone the Yatline repository."
  exit 1
}
ya pkg add wakaka6/yatline-dracula || {
  echo "Failed to install package 'wakaka6/yatline-dracula'" >&2
  exit 1
}

# Enable user services
systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber || {
  echo "Failed to enable user services" >&2
  exit 1
}

# Set permissions for GPG directory
chmod 700 ~/.gnupg || {
  echo "Failed to set permissions on ~/.gnupg" >&2
  exit 1
}

echo "User configuration successful"
