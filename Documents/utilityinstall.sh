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
cpth=$HOME/.cache/BraveSoftware
dpth=$HOME/BrowserProfiles
rpth=$HOME/BrowserProfiles/BraveSoftware
spth=$HOME/.config/BraveSoftware

if [ -d "$spth" ]; then
  rm -rf "$cpth" "$rpth"
  cp -r "$spth" "$dpth"
  echo "Brave profiles copied to control."
else
  echo "Source directory not present!"
fi
EOF

cat <<'EOF' > "$HOME"/xfer/dap
#!/usr/bin/env bash
# Delete active profile
cpth=$HOME/.cache/BraveSoftware
dpth=$HOME/.config
rpth=$HOME/.config/BraveSoftware
spth=$HOME/BrowserProfiles/BraveSoftware

if [ -d "$spth" ]; then
  rm -rf "$cpth" "$rpth"
  cp -r "$spth" "$dpth"
  echo "Active Brave profiles deleted."
else
  echo "Source directory not present!"
fi
EOF

cat <<'EOF' > "$HOME"/xfer/dotoff
#!/usr/bin/env bash
# Disable DNS over TLS
SYSTEMD_RESOLVED_CONF="/etc/NetworkManager/conf.d/10-dns-systemd-resolved.conf"
RESOLVED_CONF="/etc/systemd/resolved.conf"

# Remove the systemd-resolved configuration file if it exists
if [ -f "$SYSTEMD_RESOLVED_CONF" ]; then
  sudo rm -f "$SYSTEMD_RESOLVED_CONF"
else
  echo "Warning: $SYSTEMD_RESOLVED_CONF does not exist."
fi

# Remove the resolved.conf file if it exists
if [ -f "$RESOLVED_CONF" ]; then
  sudo rm -f "$RESOLVED_CONF"
else
  echo "Warning: $RESOLVED_CONF does not exist."
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
CONFIG_DIR="$HOME/.config/nextdns"
AGE_FILE="$CONFIG_DIR/nxtdot.zip.age"
ZIP_FILE="$CONFIG_DIR/nxtdot.zip"
SYSTEMD_RESOLVED_CONF="/etc/NetworkManager/conf.d/10-dns-systemd-resolved.conf"
RESOLVED_CONF="/etc/systemd/resolved.conf"

# Change to the NextDNS configuration directory
cd "$CONFIG_DIR" || { echo "Error: Failed to change directory to $CONFIG_DIR"; exit 1; }

# Decrypt the .age file
if [ ! -f "$AGE_FILE" ]; then
  echo "Error: File $AGE_FILE does not exist."
  exit 1
fi
age -d -o "$ZIP_FILE" "$AGE_FILE"

# Unzip the decrypted file
if [ ! -f "$ZIP_FILE" ]; then
  echo "Error: File $ZIP_FILE does not exist."
  exit 1
fi
unzip "$ZIP_FILE" && rm "$ZIP_FILE"

# Move configuration files to appropriate locations
sudo mv "$CONFIG_DIR/10-dns-systemd-resolved.conf" "$SYSTEMD_RESOLVED_CONF"
sudo mv "$CONFIG_DIR/resolved.conf" "$RESOLVED_CONF"

# Enable and restart systemd-resolved and NetworkManager
sudo systemctl enable systemd-resolved --now
sudo systemctl restart NetworkManager

# Confirm DNS over TLS is enabled
echo "DNS over TLS is enabled."
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
rsync -a "$HOME"/Downloads/.config/cmus/playlists "$HOME"/.config/cmus
rsync -a "$HOME"/Downloads/.config/{Kvantum,firejail,nextdns} "$HOME"/.config
rsync -a "$HOME"/Downloads/{.ssh,Packages,Pictures,Playlists,Videos} "$HOME"
rsync -a --exclude 'linuxnotes.txt' --exclude 'hostinstall.sh' "$HOME"/Downloads/Documents "$HOME" 
rsync -a --exclude 'log.js' --exclude 'user.js' "$HOME"/Downloads/BrowserProfiles "$HOME" 

bat cache --build
ya pack -a llanosrocas/yaziline

systemctl --user enable pipewire-pulse pipewire-pulse.socket pipewire.socket wireplumber
EOF

chmod +x "$HOME"/xfer/*
sudo chown root:root "$HOME"/xfer/*
sudo mv "$HOME"/xfer/* /usr/local/bin
rm -rf "$HOME"/xfer
