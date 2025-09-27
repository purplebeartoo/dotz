#!/usr/bin/env bash
# System Configuration Script
# Applies GTK theming, syncs user configs, installs plugins, and applies system tweaks

# Strict bash execution mode
set -euo pipefail

log() { echo -e "\033[1;32m==> $*\033[0m"; }
err() { echo -e "\033[1;31mError: $*\033[0m" >&2; exit 1; }

# User theming and GNOME settings
log "Applying GNOME interface preferences..."
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk' || err "Failed to set icon theme."
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Material-Dark' || err "Failed to set GTK theme."

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

# Install Yazi plugins and flavors
log "Installing Yazi Yatline plugin..."
if [ ! -d ~/.config/yazi/plugins/yatline.yazi ]; then
  git clone https://github.com/imsi32/yatline.yazi.git ~/.config/yazi/plugins/yatline.yazi || err "Yatline clone failed."
fi

log "Installing Yazi Gruvbox flavor..."
ya pkg add bennyyip/gruvbox-dark || err "Yazi Gruvbox Dark flavor install failed."

log "Installing Yatline Gruvbox plugin for Yazi..."
if [ ! -d ~/.config/yazi/plugins/yatline.yazi ]; then
  git clone https://github.com/imsi32/yatline-gruvbox.yazi.git ~/.config/yazi/plugins/yatline-gruvbox.yazi || err "Yatline Gruvbox clone failed."
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
sudo reflector --country 'united states' --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist || err "Reflector failed."

# Theming (GTK theme/Gruvbox)
log "Copying Gruvbox GTK theme to user directory..."
mkdir -p "$HOME/.themes"
if [ -d "/usr/share/themes/Gruvbox-Material-Dark" ]; then
  rsync -a /usr/share/themes/Gruvbox-Material-Dark "$HOME/.themes/"
  sudo chown -R "$USER:$USER" "$HOME/.themes/Gruvbox-Material-Dark"
else
  log "Gruvbox theme not found in /usr/share/themes. Skipping copy."
fi

# Theming (icon theme/Gruvbox Dark Icons GTK)
log "Copying Gruvbox icon theme to user directory..."
mkdir -p "$HOME/.icons"
if [ -d "/usr/share/icons/gruvbox-dark-icons-gtk" ]; then
  rsync -a /usr/share/icons/gruvbox-dark-icons-gtk "$HOME/.icons/"
  sudo chown -R "$USER:$USER" "$HOME/.icons/gruvbox-dark-icons-gtk"
else
  log "Gruvbox icons not found in /usr/share/icons. Skipping copy."
fi

log "Setting GTK global preferences..."
sudo tee /usr/share/gtk-3.0/settings.ini >/dev/null <<EOF
[Settings]
gtk-icon-theme-name = gruvbox-dark-icons-gtk
gtk-cursor-theme-name = BreezeX-RosePine-Linux
gtk-theme-name = Gruvbox-Material-Dark
gtk-font-name = Cantarell 11
EOF

# Flatpak overrides
sudo flatpak override --filesystem="$HOME/.themes" || err "Failed to set flatpak override for ~/.themes"
sudo flatpak override --filesystem="$HOME/.local/share/themes" || err "Failed to set flatpak override for ~/.local/share/themes"
sudo flatpak override --env=GTK_THEME=Gruvbox-Material-Dark || err "Failed to set flatpak override for GTK_THEME"
sudo flatpak override --filesystem="$HOME/.icons" || err "Failed to set flatpak override for ~/.icons"
sudo flatpak override --env=ICON_THEME=gruvbox-dark-icons-gtk || err "Failed to set flatpak override for ICON_THEME"

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

log "System configuration complete"
