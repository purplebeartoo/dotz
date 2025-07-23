#!/usr/bin/env bash
# Copy to control, alias: ctc

# Ensure the destination directory exists
dest="$HOME/BrowserProfiles"
if [ ! -d "$dest" ]; then
    echo "Destination directory $dest does not exist. Creating it."
    mkdir -p "$dest"
    if [ $? -ne 0 ]; then
        echo "Failed to create destination directory. Exiting."
        exit 1
    fi
fi

# Define paths
bcache="$HOME/.cache/BraveSoftware/Brave-Browser"
bconf="$HOME/.config/BraveSoftware"
bcont="$HOME/BrowserProfiles/BraveSoftware"
ccache="$HOME/.cache/chromium"
cconf="$HOME/.config/chromium"
ccont="$HOME/BrowserProfiles/chromium"

# Check and copy Brave profile
if [ -d "$bconf" ]; then
    echo "Removing existing Brave cache and container directories..."
    rm -rf "$bcache" "$bcont"
    if [ $? -ne 0 ]; then
        echo "Failed to remove existing Brave cache or container directories. Exiting."
        exit 1
    fi

    echo "Copying Brave profile..."
    cp -r "$bconf" "$dest"
    if [ $? -ne 0 ]; then
        echo "Failed to copy Brave profile. Exiting."
        exit 1
    fi

    echo "Brave profile copied to control."
else
    echo "Brave source directory not present!"
fi

# Check and copy Chromium profile
if [ -d "$cconf" ]; then
    echo "Removing existing Chromium cache and container directories..."
    rm -rf "$ccache" "$ccont"
    if [ $? -ne 0 ]; then
        echo "Failed to remove existing Chromium cache or container directories. Exiting."
        exit 1
    fi

    echo "Copying Chromium profile..."
    cp -r "$cconf" "$dest"
    if [ $? -ne 0 ]; then
        echo "Failed to copy Chromium profile. Exiting."
        exit 1
    fi

    echo "Chromium profile copied to control."
else
    echo "Chromium source directory not present!"
fi
