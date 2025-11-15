#!/usr/bin/env bash
# Restore backups and configure a new Arch Linux installation 

set -euo pipefail

log() { echo -e "\033[1;32m==> $*\033[0m"; }
err() { echo -e "\033[1;31mError: $*\033[0m" >&2; exit 1; }

# Sync configuration from backup
log "Syncing configuration from backup..."
rsync -a "$HOME"/Downloads/.local/share/{bubblejail,zoxide} "$HOME"/.local/share || err "User share directories sync failed."
rsync -a "$HOME"/Downloads/.config/{chromium,bat,Kvantum,nextdns} "$HOME"/.config || err "Config directories sync failed."
rsync -a "$HOME"/Downloads/{.mozilla,.ssh,BrowserProfiles,Packages,Pictures,Playlists,Videos} "$HOME" || err "User directories sync failed."
rsync -a --exclude "linuxnotes.txt" "$HOME"/Downloads/Documents "$HOME" || err "Documents sync failed."

# Build bat cache
log "Building 'bat' syntax cache..."
bat cache --build || err "Failed to build bat cache."

# Install Yazi plugins and flavors
log "Installing Yazi Yatline plugin..."
if [ ! -d "$HOME"/.config/yazi/plugins/yatline.yazi ]; then
  git clone https://github.com/imsi32/yatline.yazi.git "$HOME"/.config/yazi/plugins/yatline.yazi || err "Yatline clone failed."
fi

log "Installing Yazi Tokyo Night flavor..."
ya pkg add BennyOe/tokyo-night || err "Yazi Tokyo Night flavor install failed."

log "Installing Yatline Tokyo Night plugin for Yazi..."
ya pkg add wekauwau/yatline-tokyo-night || err "Yatline Tokyo Night plugin install failed."

# Enable user services
log "Enabling Pipewire and Wireplumber user services..."
systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber || err "Failed to enable Pipewire/Wireplumber."

# Secure GPG directory
log "Setting permissions on ~/.gnupg..."
chmod 700 ~/.gnupg || err "Failed to set permissions on ~/.gnupg."

log "User configuration successful!"

# Pacman mirrors
log "Choosing fastest mirrors with reflector..."
sudo cp /etc/pacman.d/mirrorlist  /etc/pacman.d/mirrorlist.bak || err "Failed to create Mirrorlist backup."
sudo reflector --country "United States" --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist || err "Reflector failed."

# Theming (GTK theme/Tokyonight Dark)
log "Copying Tokyonight Dark GTK theme to user directory..."
mkdir -p "$HOME/.themes"
if [ -d "/usr/share/themes/Tokyonight-Dark" ]; then
  rsync -a /usr/share/themes/Tokyonight-Dark "$HOME/.themes/"
else
  log "Tokyonight Dark theme not found in /usr/share/themes. Skipping copy."
fi

# Theming (icon theme/Yaru Blue Icons GTK)
log "Copying Yaru Blue icon theme to user directory..."
mkdir -p "$HOME/.icons"
if [ -d "/usr/share/icons/Yaru-Blue" ]; then
  rsync -a /usr/share/icons/Yaru-Blue "$HOME/.icons/"
else
  log "Yaru Blue icons not found in /usr/share/icons. Skipping copy."
fi

# Theme GTK file chooser 
gsettings set org.gnome.desktop.interface gtk-theme Tokyonight-Dark || err "Failed to set GTK file chooser theme." 

# Create journal size configuration
log "Setting journal size limit to 50M"
sudo mkdir -p /etc/systemd/journald.conf.d/ || err "Failed to create directory."
sudo tee /etc/systemd/journald.conf.d/99-journal-size.conf << EOF || err "Failed to write journal size config."
[Journal]
SystemMaxUse=50M
EOF

# PAM configuration
log "Appending ZDOTDIR to pam_env.conf..."
if ! sudo cp /etc/security/pam_env.conf /etc/security/pam_env.conf.bak; then
  err "Failed to backup pam_env.conf."
fi

if ! sudo tee -a /etc/security/pam_env.conf <<EOF
ZDOTDIR DEFAULT=$HOME/.config/zsh
EOF
then
  err "Failed to append ZDOTDIR to pam_env.conf."
fi

# Podman configuration
log "Configuring user subuids/subgids for Podman..."
if ! sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"; then
  err "Failed to configure user subuids/subgids for Podman."
fi

log "Setting container registry search order..."
if ! sudo tee /etc/containers/registries.conf.d/99-unqualified-search-registries.conf >/dev/null <<EOF
unqualified-search-registries = ["docker.io"]
EOF
then
  err "Failed to set container registry search order."
fi

# Create Chromium policies directory and configuration files
log "Creating Chromium policy configuration..."
sudo mkdir -p /etc/chromium/policies/managed || err "Failed to create Chromium policies directory."

# Create 99-doh.json
if ! sudo tee /etc/chromium/policies/managed/99-doh.json > /dev/null << 'EOF'
{
  "DnsOverHttpsMode": "secure"
}
EOF
then
  err "Failed to create /etc/chromium/policies/managed/99-doh.json."
fi

# Create 99-dohserver.json
if ! sudo tee /etc/chromium/policies/managed/99-dohserver.json > /dev/null << 'EOF'
{
  "DnsOverHttpsTemplates": "https://one.one.one.one/dns-query"
}
EOF
then
  err "Failed to create /etc/chromium/policies/managed/99-dohserver.json."
fi

# Create 99-genai.json
if ! sudo tee /etc/chromium/policies/managed/99-genai.json > /dev/null << 'EOF'
{
  "GenAILocalFoundationalModelSettings": 1
}
EOF
then
  err "Failed to create /etc/chromium/policies/managed/99-genai.json."
fi

log "Chromium policy configuration complete."

log "System configuration complete."
