#!/usr/bin/env bash
# Restore backups and configure a new Arch Linux installation

set -euo pipefail

log()    { echo -e "\033[1;32m==> $*\033[0m"; }
err()    { echo -e "\033[1;31mError: $*\033[0m" >&2; exit 1; }
run()    { "$@" || err "Command failed: $*"; }
backup() { sudo cp "$1" "$1.bak" || err "Failed to backup $1."; }

# Restore user data and configuration
log "Syncing configuration from backup..."
run rsync -a "$HOME"/Downloads/.local/share/{bubblejail,zoxide} "$HOME"/.local/share
run rsync -a "$HOME"/Downloads/.config/{chromium,bat,Kvantum,mozilla,nextdns} "$HOME"/.config
run rsync -a "$HOME"/Downloads/{.ssh,BrowserProfiles,Packages,Pictures,Playlists,Videos} "$HOME"
run rsync -a --exclude "linuxnotes" "$HOME"/Downloads/Documents "$HOME"

# Build bat cache
log "Rebuilding bat syntax cache..."
run bat cache --build

# Install Yazi plugins and flavors
log "Installing Yaziline plugin..."
run ya pkg add llanosrocas/yaziline

log "Installing Yazi Tokyo Night flavor..."
run ya pkg add BennyOe/tokyo-night

# Enable Pipewire and Wireplumber user services
log "Enabling Pipewire & Wireplumber user services..."
run systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber

# Secure GPG directory
log "Securing ~/.gnupg permissions..."
run chmod 700 ~/.gnupg

log "User configuration restoration complete."

# Pacman mirrors
log "Selecting fastest mirrors with reflector..."
backup /etc/pacman.d/mirrorlist
run sudo reflector --country "United States" --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# GTK & Icon Theming
log "Copying Tokyonight Dark GTK theme to ~/.themes..."
mkdir -p "$HOME/.themes"
if [ -d "/usr/share/themes/Tokyonight-Dark" ]; then
  run rsync -a /usr/share/themes/Tokyonight-Dark "$HOME/.themes/"
else
  log "Tokyonight Dark theme not found. Skipping."
fi

log "Copying Tokyonight-Dark-Cyan icon theme to ~/.icons..."
mkdir -p "$HOME/.icons"
if [ -d "/usr/share/icons/Tokyonight-Dark-Cyan" ]; then
  run rsync -a /usr/share/icons/Tokyonight-Dark-Cyan "$HOME/.icons/"
else
  log "Tokyonight-Dark-Cyan icons not found. Skipping."
fi

log "Setting GTK theme to Tokyonight-Dark..."
run gsettings set org.gnome.desktop.interface gtk-theme Tokyonight-Dark

# Journal size config
log "Limiting systemd journal size to 50M..."
run sudo mkdir -p /etc/systemd/journald.conf.d/
run sudo tee /etc/systemd/journald.conf.d/99-journal-size.conf > /dev/null <<EOF
[Journal]
SystemMaxUse=50M
EOF

# PAM configuration for ZDOTDIR
log "Configuring ZDOTDIR in pam_env.conf..."
backup /etc/security/pam_env.conf
echo -e "\nZDOTDIR DEFAULT=$HOME/.config/zsh" | sudo tee -a /etc/security/pam_env.conf > /dev/null \
  || err "Failed to append ZDOTDIR."

# Set Podman user subuids and Docker registry search
log "Configuring Podman user subuids/subgids..."
run sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

log "Setting unqualified container registry search to docker.io..."
run sudo tee /etc/containers/registries.conf.d/99-unqualified-search-registries.conf > /dev/null <<EOF
unqualified-search-registries = ["docker.io"]
EOF

# Chromium policies
log "Writing Chromium policies..."
run sudo mkdir -p /etc/chromium/policies/managed

run sudo tee /etc/chromium/policies/managed/99-doh.json > /dev/null <<EOF
{
  "DnsOverHttpsMode": "secure"
}
EOF

run sudo tee /etc/chromium/policies/managed/99-dohserver.json > /dev/null <<EOF
{
  "DnsOverHttpsTemplates": "https://one.one.one.one/dns-query"
}
EOF

run sudo tee /etc/chromium/policies/managed/99-genai.json > /dev/null <<EOF
{
  "GenAILocalFoundationalModelSettings": 1
}
EOF

log "Chromium policy configuration complete."
log "System configuration complete."
