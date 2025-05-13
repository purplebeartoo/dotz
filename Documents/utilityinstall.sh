#!/usr/bin/env bash
# Utility scripts
mkdir "$HOME"/xfer

cat <<'EOF' > "$HOME"/xfer/awc
#!/usr/bin/env bash
# Admin write config
# Mirrors
reflector --country 'united states' --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Limit logs
cp /etc/systemd/journald.conf /etc/systemd/journald.conf.old
sed -i -e 's/#SystemMaxUse=/SystemMaxUse=100M/' /etc/systemd/journald.conf
cp /etc/logrotate.conf /etc/logrotate.conf.old
sed -i -e 's/rotate 4/rotate 2/' /etc/logrotate.conf

# Misc
cp /etc/security/pam_env.conf /etc/security/pam_env.conf.old
echo 'ZDOTDIR DEFAULT=@{HOME}/.config/zsh' >> /etc/security/pam_env.conf
echo 'blacklist iTCO_wdt' > /etc/modprobe.d/nobeep.conf
usermod -a -G input ck

# Ollama
usermod -a -G ollama ck
echo '[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3

[Install]
WantedBy=default.target' > /etc/systemd/system/ollama.service

# Pacman
cp /etc/pacman.conf /etc/pacman.conf.old
sed -i -e '
  s/#Color/Color/
  s/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf

# Symlink
ln -s /usr/bin/ghostty /usr/bin/xterm

# Theming
mkdir /home/ck/.themes
cp -r /usr/share/themes/Dracula /home/ck/.themes/Dracula
chown -R ck:ck /home/ck/.themes
flatpak override --filesystem=/home/ck/.themes

echo '[Settings]
gtk-icon-theme-name = Tela-circle-dracula-dark
gtk-cursor-theme-name = BreezeX-RosePine-Linux
gtk-theme-name = Dracula
gtk-font-name = Cantarell 11' >  /usr/share/gtk-3.0/settings.ini
EOF

cat <<'EOF' > "$HOME"/xfer/backup
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

cat <<'EOF' > "$HOME"/xfer/ctc
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

cat <<'EOF' > "$HOME"/xfer/dap
#!/usr/bin/env bash
# Delete active profile
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

cat <<'EOF' > "$HOME"/xfer/dotoff
#!/usr/bin/env bash
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

cat <<'EOF' > "$HOME"/xfer/doton
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

cat <<'EOF' > "$HOME"/xfer/hyprdown
#!/usr/bin/env bash
# Hyprdown
wl-copy -c < /dev/null
rm -rf "$HOME"/.cache/chromium
rm -rf "$HOME"/.config/chromium
rm -rf "$HOME"/.ollama/history
poweroff
EOF

cat <<'EOF' > "$HOME"/xfer/rs
#!/usr/bin/env bash
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interative-ripgrep-launcher
# Ripgrep search
RG_PREFIX="rg --color=always --column --glob=\!timeshift --glob=\!.var --hidden --line-number --no-heading --smart-case"
INITIAL_QUERY="${*:-}"
fzf --ansi --disabled --query "$INITIAL_QUERY" \
  --bind "start:reload:$RG_PREFIX {q}" \
  --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
  --delimiter : \
  --preview 'bat --color=always {1} --highlight-line {2}' \
  --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
  --bind 'enter:become(nvim {1} +{2})'
EOF

cat <<'EOF' > "$HOME"/xfer/rup
#!/usr/bin/env bash
# Remove unneeded packages
pacman -Qtdq | pacman -Rns -
pacman -Qqd | pacman -Rsu -
echo "Unneeded Packages Removed ;)"
EOF

cat <<'EOF' > "$HOME"/xfer/sbk
#!/usr/bin/env bash
# Sync backup
backup_source="$HOME/backup-$(date +"%Y-%m-%d").tar.zst.age"

backup_destinations=(
  "/run/media/ck/sanc"
  "/run/media/ck/san3"
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

cat <<'EOF' > "$HOME"/xfer/uwc
#!/usr/bin/env bash
# User write config
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula' 

# Sync
rsync -a "$HOME"/Downloads/.local/share/bubblejail "$HOME"/.local/share
rsync -a "$HOME"/Downloads/.config/cmus/playlists "$HOME"/.config/cmus
rsync -a "$HOME"/Downloads/.config/{BraveSoftware,chromium,Kvantum,nextdns} "$HOME"/.config
rsync -a "$HOME"/Downloads/{.ssh,Packages,Pictures,Playlists,Videos} "$HOME"
rsync -a --exclude 'linuxnotes.txt' --exclude 'hostinstall.sh' "$HOME"/Downloads/Documents "$HOME" 
rsync -a --exclude 'log.js' --exclude 'user.js' "$HOME"/Downloads/BrowserProfiles "$HOME" 

bat cache --build
ya pack -a llanosrocas/yaziline

systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber

chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg
EOF

chmod +x "$HOME"/xfer/*
sudo chown root:root "$HOME"/xfer/*
sudo mv "$HOME"/xfer/* /usr/local/bin
rm -rf "$HOME"/xfer
