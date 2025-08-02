#!/usr/bin/env bash
# Admin write config

# Strict bash execution mode
set -euo pipefail

# Choose mirrors
sudo reflector --country 'united states' --age 12 --n 6 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Theming
mkdir -p /home/"$USER"/.themes
if [ -d "/usr/share/themes/Dracula" ]; then
  cp -r /usr/share/themes/Dracula /home/"$USER"/.themes
  sudo chown -R "$USER":"$USER" /home/"$USER"/.themes
else
  echo "Error: Dracula theme not found. Skipping theme copy."
fi

# GTK settings
sudo tee /usr/share/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-icon-theme-name = Tela-circle-dracula-dark
gtk-cursor-theme-name = BreezeX-RosePine-Linux
gtk-theme-name = Dracula
gtk-font-name = Cantarell 11
EOF

# Logging configuration
sudo cp /etc/systemd/journald.conf /etc/systemd/journald.conf.old
sudo sed -i 's/#Storage=auto/Storage=volatile/' /etc/systemd/journald.conf

sudo cp /etc/logrotate.conf /etc/logrotate.conf.old
sudo sed -i 's/rotate 4/rotate 2/' /etc/logrotate.conf

# PAM configuration
sudo cp /etc/security/pam_env.conf /etc/security/pam_env.conf.old
sudo tee -a /etc/security/pam_env.conf <<EOF
ZDOTDIR DEFAULT=$HOME/.config/zsh
EOF

# Podman configuration
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

sudo tee /etc/containers/registries.conf.d/10-unqualified-search-registries.conf <<EOF
unqualified-search-registries = ["docker.io"]
EOF

# Ensure the 'input' group exists and add user 'ck' to it
if ! getent group input > /dev/null; then
  echo "Group 'input' does not exist. Creating it now..."
  if sudo groupadd input; then
    echo "Group 'input' created successfully."
  else
    echo "Failed to create group 'input'. Exiting."
    exit 1
  fi
else
  echo "Group 'input' already exists."
fi

# Check if the user 'ck' exists
if ! id ck > /dev/null; then
  echo "User 'ck' does not exist. Cannot proceed."
  exit 1
fi

# Add user 'ck' to the 'input' group
echo "Adding user 'ck' to the group 'input'..."
if sudo usermod -aG input ck; then
  echo "User 'ck' has been successfully added to the group 'input'."
else
  echo "Failed to add user 'ck' to the group 'input'."
  exit 1
fi

echo "System settings configured successfully."
