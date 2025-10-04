#!/usr/bin/env bash
# System Configuration Script
# Applies GTK theming, syncs user configs, installs plugins, and applies system tweaks

# Strict bash execution mode
set -euo pipefail

log() { echo -e "\033[1;32m==> $*\033[0m"; }
err() { echo -e "\033[1;31mError: $*\033[0m" >&2; exit 1; }

# Sync configuration from backup
log "Syncing configuration from backup..."
rsync -a "$HOME"/Downloads/.local/share/{bubblejail,zoxide} "$HOME"/.local/share || err "User share directories sync failed."
rsync -a "$HOME"/Downloads/.config/cmus/playlists "$HOME"/.config/cmus || err "Cmus playlists sync failed."
rsync -a "$HOME"/Downloads/.config/{BraveSoftware,chromium,Kvantum,nextdns} "$HOME"/.config || err "Config directories sync failed."
rsync -a "$HOME"/Downloads/{.ssh,BrowserProfiles,Packages,Pictures,Playlists,Videos} "$HOME" || err "User directories sync failed."
rsync -a --exclude "linuxnotes.txt" "$HOME"/Downloads/Documents "$HOME" || err "Documents sync failed."

# Build bat cache
log "Building 'bat' syntax cache..."
bat cache --build || err "Failed to build bat cache."

# Install Yazi plugins and flavors
log "Installing Yazi Yatline plugin..."
if [ ! -d "$HOME"/.config/yazi/plugins/yatline.yazi ]; then
  git clone https://github.com/imsi32/yatline.yazi.git "$HOME"/.config/yazi/plugins/yatline.yazi || err "Yatline clone failed."
fi

log "Installing Yazi Gruvbox flavor..."
ya pkg add bennyyip/gruvbox-dark || err "Yazi Gruvbox Dark flavor install failed."

log "Installing Yatline Gruvbox plugin for Yazi..."
if [ ! -d "$HOME"/.config/yazi/plugins/yatline-gruvbox.yazi ]; then
  git clone https://github.com/imsi32/yatline-gruvbox.yazi.git "$HOME"/.config/yazi/plugins/yatline-gruvbox.yazi || err "Yatline Gruvbox clone failed."
fi

# Enable user services
log "Enabling Pipewire and Wireplumber user services..."
systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber || err "Failed to enable Pipewire/Wireplumber."

# Secure GPG directory
log "Setting permissions on ~/.gnupg..."
chmod 700 ~/.gnupg || err "Failed to set permissions on ~/.gnupg."

log "User configuration successful!"

# Pacman mirrors
log "Choosing fastest mirrors with reflector..."
sudo cp /etc/pacman.d/mirrorlist  /etc/pacman.d/mirrorlist.bak || err "Failed to create Mirrorlist backup"
sudo reflector --country "United States" --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist || err "Reflector failed."

# Theming (GTK theme/Gruvbox)
log "Copying Gruvbox GTK theme to user directory..."
mkdir -p "$HOME/.themes"
if [ -d "/usr/share/themes/Gruvbox-Material-Dark" ]; then
  rsync -a /usr/share/themes/Gruvbox-Material-Dark "$HOME/.themes/"
else
  log "Gruvbox theme not found in /usr/share/themes. Skipping copy."
fi

# Theming (icon theme/Gruvbox Dark Icons GTK)
log "Copying Gruvbox icon theme to user directory..."
mkdir -p "$HOME/.icons"
if [ -d "/usr/share/icons/gruvbox-dark-icons-gtk" ]; then
  rsync -a /usr/share/icons/gruvbox-dark-icons-gtk "$HOME/.icons/"
else
  log "Gruvbox icons not found in /usr/share/icons. Skipping copy."
fi

# Theme GTK file chooser 
gsettings set org.gnome.desktop.interface gtk-theme Gruvbox-Material-Dark

# Create journal size configuration
log "Setting journal size limit to 50M"
sudo mkdir -p /etc/systemd/journald.conf.d/ || err "Failed to create directory"
sudo tee /etc/systemd/journald.conf.d/99-journal-size.conf << EOF || err "Failed to write configuration"
[Journal]
SystemMaxUse=50M
EOF

# PAM configuration
log "Appending ZDOTDIR to pam_env.conf..."
sudo cp /etc/security/pam_env.conf /etc/security/pam_env.conf.bak
sudo tee -a /etc/security/pam_env.conf <<EOF
ZDOTDIR DEFAULT=$HOME/.config/zsh
EOF

# Podman configuration
log "Configuring user subuids/subgids for Podman..."
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

log "Setting container registry search order..."
sudo tee /etc/containers/registries.conf.d/99-unqualified-search-registries.conf >/dev/null <<EOF
unqualified-search-registries = ["docker.io"]
EOF

log "System configuration complete"
