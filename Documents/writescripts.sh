#!/usr/bin/env bash
# Write and concatenate utility scripts
# Create a new temp directory
temp_dir=$(mktemp -d)
if ! temp_dir=$(mktemp -d); then
  echo "Failed to create temporary directory."
  exit 1
fi

# Write the utility scripts to temp
cat <<'EOF' > "$temp_dir"/aic
#!/usr/bin/env bash
# AI Code
# Check if the ollama container is running
if ! podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  # Start the container
  podman start ollama
fi

# Launch qwen2.5-coder
ghostty -e podman exec -it ollama ollama run qwen2.5-coder:14b
EOF

cat <<'EOF' > "$temp_dir"/aig
#!/usr/bin/env bash
# AI General
# Check if the ollama container is running
if ! podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  # Start the container
  podman start ollama
fi

# Launch Qwen3
ghostty -e podman exec -it ollama ollama run qwen3:14b
EOF

cat <<'EOF' > "$temp_dir"/awc
#!/usr/bin/env bash
# Admin write config
# Mirrors
reflector --country 'united states' --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Flatpak theming
mkdir /home/ck/.themes
cp -r /usr/share/themes/Dracula /home/ck/.themes
sudo chown -R ck:ck /home/ck/.themes

# GTK settings
echo '[Settings]
gtk-icon-theme-name = Tela-circle-dracula-dark
gtk-cursor-theme-name = BreezeX-RosePine-Linux
gtk-theme-name = Dracula
gtk-font-name = Cantarell 11' >  /usr/share/gtk-3.0/settings.ini

# Limit logs
cp /etc/systemd/journald.conf /etc/systemd/journald.conf.old
sed -i -e 's/#SystemMaxUse=/SystemMaxUse=100M/' /etc/systemd/journald.conf
cp /etc/logrotate.conf /etc/logrotate.conf.old
sed -i -e 's/rotate 4/rotate 2/' /etc/logrotate.conf

# Misc
cp /etc/security/pam_env.conf /etc/security/pam_env.conf.old
echo 'ZDOTDIR DEFAULT=@{HOME}/.config/zsh' >> /etc/security/pam_env.conf
echo 'blacklist iTCO_wdt' > /etc/modprobe.d/nobeep.conf

# Ollama via Podman
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 ck
sudo podman system migrate
echo 'unqualified-search-registries = ["docker.io"]' >  /etc/containers/registries.conf.d/10-unqualified-search-registries.conf
EOF

cat <<'EOF' > "$temp_dir"/backup
#!/usr/bin/env bash
# Backup
backup_file="backup-$(date +"%Y-%m-%d").tar.zst"
directories=(
  ".config"
  ".local/share/bubblejail"
  ".local/share/flatpak/overrides"
  ".ssh"
  "BrowserProfiles"
  "Documents"
  "Packages"
  "Pictures"
  "Playlists"
  "Videos"
)

# Go home
cd "$HOME" || { echo "Error: Failed to change directory to $HOME"; exit 1; }

# Check source directories
for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Warning: Directory $dir does not exist."
    exit 1
  fi
done

# Create backup
if ! tar -I 'zstdmt --fast=10' -vcf "$backup_file" "${directories[@]}"; then
  echo "Error: Failed to create tar archive."
  exit 1
fi

# Encrypt backup
if ! age -e -p -o "${backup_file}.age" "$backup_file"; then
  echo "Error: Failed to encrypt the backup."
  rm "$backup_file"
  exit 1
fi

# Remove unencrypted backup
rm "$backup_file"

echo "Backup complete."
EOF

cat <<'EOF' > "$temp_dir"/ctc
#!/usr/bin/env bash
# Copy to control
bcache=$HOME/.cache/BraveSoftware/Brave-Browser
bconf=$HOME/.config/BraveSoftware
bcont=$HOME/BrowserProfiles/BraveSoftware
ccache=$HOME/.cache/chromium
cconf=$HOME/.config/chromium
ccont=$HOME/BrowserProfiles/chromium
dest=$HOME/BrowserProfiles

# Check and copy Brave profile
if [ -d "$bconf" ]; then
  rm -rf "$bcache" "$bcont"
  cp -r "$bconf" "$dest"
  echo "Brave profile copied to control."
else
  echo "Brave source directory not present!"
fi

# Check and copy Chromium profile
if [ -d "$cconf" ]; then
  rm -rf "$ccache" "$ccont"
  cp -r "$cconf" "$dest"
  echo "Chromium profile copied to control."
else
  echo "Chromium source directory not present!"
fi
EOF

cat <<'EOF' > "$temp_dir"/dcp
#!/usr/bin/env bash
# Delete Chromium profile
ccache=$HOME/.cache/chromium
cconf=$HOME/.config/chromium
ccont=$HOME/BrowserProfiles/chromium
dest=$HOME/.config

if [ -d "$ccont" ]; then
  rm -rf "$ccache" "$cconf"
  cp -r "$ccont" "$dest"
  if [ -t 1 ]; then
    echo "Active Chromium profile deleted."
  fi
else
  if [ -t 1 ]; then
    echo "Source directory not present!"
  fi
fi
EOF

cat <<'EOF' > "$temp_dir"/dotoff
#!/usr/bin/env bash
# Disable DNS over TLS
systemd_resolved_conf="/etc/NetworkManager/conf.d/10-dns-systemd-resolved.conf"
resolved_conf="/etc/systemd/resolved.conf"

# Remove the systemd-resolved configuration file if it exists
if [ -f "$systemd_resolved_conf" ]; then
  sudo rm -f "$systemd_resolved_conf"
else
  echo "Warning: $systemd_resolved_conf does not exist."
fi

# Remove the resolved.conf file if it exists
if [ -f "$resolved_conf" ]; then
  sudo rm -f "$resolved_conf"
else
  echo "Warning: $resolved_conf does not exist."
fi

# Disable and stop systemd-resolved service
sudo systemctl disable systemd-resolved --now

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Confirm DNS over TLS is disabled
echo "DNS over TLS is disabled."
EOF

cat <<'EOF' > "$temp_dir"/doton
#!/usr/bin/env bash
# Enable DNS over TLS
config_dir="$HOME/.config/nextdns"
age_file="$config_dir/nxtdot.zip.age"
zip_file="$config_dir/nxtdot.zip"
systemd_resolved_conf="/etc/NetworkManager/conf.d/10-dns-systemd-resolved.conf"
resolved_conf="/etc/systemd/resolved.conf"

# Change to the NextDNS configuration directory
cd "$config_dir" || { echo "Error: Failed to change directory to $config_dir"; exit 1; }

# Decrypt the .age file
if [ ! -f "$age_file" ]; then
  echo "Error: File $age_file does not exist."
  exit 1
fi
age -d -o "$zip_file" "$age_file"

# Unzip the decrypted file
if [ ! -f "$zip_file" ]; then
  echo "Error: File $zip_file does not exist."
  exit 1
fi
unzip "$zip_file" && rm "$zip_file"

# Move configuration files to appropriate locations
sudo mv "$config_dir/10-dns-systemd-resolved.conf" "$systemd_resolved_conf"
sudo mv "$config_dir/resolved.conf" "$resolved_conf"

# Enable systemd-resolved and restart NetworkManager
sudo systemctl enable systemd-resolved --now
sudo systemctl restart NetworkManager

# Confirm DNS over TLS is enabled
echo "DNS over TLS is enabled."
EOF

cat <<'EOF' > "$temp_dir"/hyprdown
#!/usr/bin/env bash
# Hyprdown
# Function to safely remove a file
safe_rm_file() {
    local file="$1"
    if [ -f "$file" ]; then
        rm "$file"
    fi
}

# Function to clear clipboard
clear_clipboard() {
    wl-copy -c < /dev/null
}

# Remove Ollama history
safe_rm_file "$HOME/.local/share/containers/storage/volumes/ollama/_data/history"

clear_clipboard
poweroff
EOF

cat <<'EOF' > "$temp_dir"/osp
#!/usr/bin/env bash
# Ollama stop
# Check if the ollama container is running
if podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  # Stop the container
  if podman stop ollama > /dev/null 2>&1; then
    echo "Ollama stopped successfully."
  else
    echo "Failed to stop Ollama." >&2
    exit 1
  fi
else
  echo "Ollama is not running."
fi
EOF

cat <<'EOF' > "$temp_dir"/ost
#!/usr/bin/env bash
# Ollama start
# Check if the ollama container is running
if ! podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  # Start the container
  if podman start ollama > /dev/null 2>&1; then
    echo "Ollama started successfully."
  else
    echo "Failed to start Ollama." >&2
    exit 1
  fi
else
  echo "Ollama is already running."
fi
EOF

cat <<'EOF' > "$temp_dir"/rs
#!/usr/bin/env bash
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interative-ripgrep-launcher
# Ripgrep search
RG_PREFIX="rg --color=always --column --glob=\!.var --glob=\!containers --glob=\!timeshift --hidden --line-number --no-heading --smart-case"
INITIAL_QUERY="${*:-}"
fzf --ansi --disabled --query "$INITIAL_QUERY" \
  --bind "start:reload:$RG_PREFIX {q}" \
  --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
  --delimiter : \
  --preview 'bat --color=always {1} --highlight-line {2}' \
  --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
  --bind 'enter:become(nvim {1} +{2})'
EOF

cat <<'EOF' > "$temp_dir"/rup
#!/usr/bin/env bash
# Remove unneeded packages
pacman -Qtdq | pacman -Rns -
pacman -Qqd | pacman -Rsu -
echo "Unneeded Packages Removed ;)"
EOF

cat <<'EOF' > "$temp_dir"/sbk
#!/usr/bin/env bash
# Sync backup
backup_source="$HOME/backup-$(date +"%Y-%m-%d").tar.zst.age"
backup_destinations=(
  "/run/media/ck/sam3"
  "/run/media/ck/samc"
  "/home/ck/Downloads"
)

# Sync function
sync_backup() {
  source_file="$1"
  shift
  destinations=("$@")

  # Check source file
  if [[ ! -f "$source_file" ]]; then
    echo "Source file $source_file does not exist."
    exit 1
  fi

  # Check destinations
  for dest in "${destinations[@]}"; do
    if [[ ! -d "$dest" ]]; then
      echo "Destination directory $dest does not exist."
      exit 1
    fi

    # Copy
    echo "Copying $source_file to $dest"
    cp -a "$source_file" "$dest"
    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
      echo "Failed to copy $source_file to $dest"
      exit 1
    fi
  done

  # Remove source file
  rm "$source_file"
  exit_code=$?
  if [[ $exit_code -eq 0 ]]; then
    echo "Source file $source_file has been deleted."
  else
    echo "Failed to delete source file $source_file."
    exit 1
  fi
}

sync_backup "$backup_source" "${backup_destinations[@]}"
echo "Backup sync complete."
EOF

cat <<'EOF' > "$temp_dir"/upo
#!/bin/env bash
# Update Podman Ollama
# Function to check if the ollama container is running and stop it
stop_ollama_if_running() {
  if podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
    echo "Stopping the ollama container..."
    podman stop ollama
  fi
}

# Remove the ollama container
echo "Removing the ollama container..."
podman rm ollama

# Pull the latest ollama image
echo "Pulling the latest ollama image..."
podman pull ollama/ollama:rocm

# Run the ollama container with specified options
echo "Running the ollama container..."
podman run --pull newer --detach --replace \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --name ollama \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  ollama/ollama:rocm

echo "Ollama container has been updated and started."
EOF

cat <<'EOF' > "$temp_dir"/uwc
#!/usr/bin/env bash
# User write config
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula' 

# Sync
rsync -a "$HOME"/Downloads/.local/share/bubblejail "$HOME"/.local/share
rsync -a "$HOME"/Downloads/.config/cmus/playlists "$HOME"/.config/cmus
rsync -a "$HOME"/Downloads/.config/{BraveSoftware,chromium,Kvantum,nextdns} "$HOME"/.config
rsync -a "$HOME"/Downloads/{.ssh,BrowserProfiles,Packages,Pictures,Playlists,Videos} "$HOME"
rsync -a --exclude 'hostinstall.sh' --exclude 'linuxnotes.txt' --exclude 'writescripts.sh' "$HOME"/Downloads/Documents "$HOME"

bat cache --build

ya pkg add llanosrocas/yaziline

systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber

chmod 700 ~/.gnupg
EOF

# Copy scripts to their final destination
for file in "$temp_dir"/*; do
  # Check if the item is a regular file
  if [ -f "$file" ]; then
    # Make the file executable
    chmod +x "$file"
    # Change ownership to root
    sudo chown root:root "$file"
    # Move the file to /usr/local/bin
    sudo cp "$file" /usr/local/bin/
  fi
done

# Concatenate to a single file for error checking
output_file="$HOME/Documents/utilityscripts.sh"

# Remove the output file if it already exists
if [ -f "$output_file" ]; then
  rm "$output_file"
fi

# Create a new concatenated file
for file in "$temp_dir"/*; do
  # Check if the item is a regular file
  if [ -f "$file" ]; then
    # Append an empty line before each script for separation
    echo >> "$output_file"
    cat "$file" >> "$output_file"
  fi
done

# Remove the leading empty line
sed -i '1{/^$/d;}' "$output_file"

# Remove the transfer directory
rm -rf "$temp_dir"
