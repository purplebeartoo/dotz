#!/usr/bin/env bash
# Remove unneeded packages, alias: rup

# Remove orphaned packages
pacman -Qtdq | sudo xargs -r pacman -Rns 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error occurred while removing orphaned packages. Exiting."
  exit 1
fi

# Remove packages not needed by any user
pacman -Qqd | sudo xargs -r pacman -Rsu 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error occurred while removing unused packages. Exiting."
  exit 1
fi

echo "Removed any unneeded packages."
