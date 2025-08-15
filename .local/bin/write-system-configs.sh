#!/usr/bin/env bash
# System Configuration Script
# Applies GTK theming, syncs user configs, installs plugins, and applies system tweaks

# Strict bash execution mode
set -euo pipefail

log() { echo -e "\033[1;32m==> $*\033[0m"; }
err() { echo -e "\033[1;31mError: $*\033[0m" >&2; exit 1; }

# User theming and GNOME settings 
log "Applying GNOME interface preferences..."
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula-dark' || err "Failed to set icon theme."
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula' || err "Failed to set GTK theme."

# Sync configuration from backup 
log "Syncing configuration from backup..."
rsync -a "$HOME"/Downloads/.local/share/bubblejail "$HOME"/.local/share || err "Bubblejail sync failed."
rsync -a "$HOME"/Downloads/.config/cmus/playlists "$HOME"/.config/cmus || err "Cmus playlists sync failed."
rsync -a "$HOME"/Downloads/.config/{BraveSoftware,chromium,Kvantum,nextdns} "$HOME"/.config || err "Config directories sync failed."
rsync -a "$HOME"/Downloads/{.ssh,BrowserProfiles,Packages,Pictures,Playlists,Videos} "$HOME" || err "User directories sync failed."
rsync -a --exclude 'linuxnotes.txt' "$HOME"/Downloads/Documents "$HOME" || err "Documents sync failed."

# Build bat cache 
log "Building 'bat' syntax cache..."
bat cache --build || err "Failed to build bat cache."

# Install Yazi flavors and plugins 
log "Installing Yazi Dracula flavor..."
ya pkg add yazi-rs/flavors:dracula || err "Yazi Dracula flavor install failed."

log "Installing Yatline plugin for Yazi..."
if [ ! -d ~/.config/yazi/plugins/yatline.yazi ]; then
  git clone --depth 1 https://github.com/imsi32/yatline.yazi.git ~/.config/yazi/plugins/yatline.yazi || err "Yatline clone failed."
fi

ya pkg add wakaka6/yatline-dracula || err "Yatline Dracula flavor install failed."

# Enable user services 
log "Enabling Pipewire and Wireplumber user services..."
systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber || err "Failed to enable Pipewire/Wireplumber."

# Secure GPG directory 
log "Setting permissions on ~/.gnupg..."
chmod 700 ~/.gnupg || err "Failed to set permissions on ~/.gnupg."

log "User configuration successful!"

# Pacman mirrors 
log "Choosing fastest mirrors with reflector..."
sudo reflector --country 'united states' --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist || err "Reflector failed."

# Theming (GTK/Dracula) 
log "Copying Dracula GTK theme to user directory..."
mkdir -p "$HOME/.themes"
if [ -d "/usr/share/themes/Dracula" ]; then
  rsync -a /usr/share/themes/Dracula "$HOME/.themes/"
  sudo chown -R "$USER:$USER" "$HOME/.themes/Dracula"
else
  log "Dracula theme not found in /usr/share/themes. Skipping copy."
fi

log "Setting GTK global preferences..."
sudo tee /usr/share/gtk-3.0/settings.ini >/dev/null <<EOF
[Settings]
gtk-icon-theme-name = Tela-circle-dracula-dark
gtk-cursor-theme-name = BreezeX-RosePine-Linux
gtk-theme-name = Dracula
gtk-font-name = Cantarell 11
EOF

# Logging configuration 
log "Tweaking system logging settings..."
sudo cp /etc/systemd/journald.conf /etc/systemd/journald.conf.old
sudo sed -i 's/#Storage=auto/Storage=volatile/' /etc/systemd/journald.conf

sudo cp /etc/logrotate.conf /etc/logrotate.conf.old
sudo sed -i 's/rotate 4/rotate 2/' /etc/logrotate.conf

# PAM configuration 
log "Appending ZDOTDIR to pam_env.conf..."
sudo cp /etc/security/pam_env.conf /etc/security/pam_env.conf.old
sudo tee -a /etc/security/pam_env.conf <<EOF
ZDOTDIR DEFAULT=$HOME/.config/zsh
EOF

# Podman configuration 
log "Configuring user subuids/subgids for Podman..."
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

log "Setting container registry search order..."
sudo tee /etc/containers/registries.conf.d/10-unqualified-search-registries.conf >/dev/null <<EOF
unqualified-search-registries = ["docker.io"]
EOF

log "System configuration complete!"
