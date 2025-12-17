#!/usr/bin/env bash
# System setup bootstrapper

set -euo pipefail

tmpscripts_dir="${1:-$HOME/tmpscripts}" # allow custom target, default to ~/tmpscripts

required_cmds=(wget chmod)
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "error: required command '$cmd' not found. please install it first."
    exit 1
  fi
done

echo "creating temporary directory at: $tmpscripts_dir"
if ! mkdir -p "$tmpscripts_dir"; then
  echo "error: failed to create directory $tmpscripts_dir"
  exit 1
fi

# array of source and dest filenames
declare -A files_to_download=(
  [package-install.sh]="packinst"
  [write-system-configs.sh]="wsc"
)

base_url="https://raw.githubusercontent.com/purplebeartoo/dotz/master/.local/bin"

download_file() {
  local url="$1"
  local dest="$2"
  echo -n "downloading $url ... "
  if wget --quiet -O "$dest" "$url"; then
    chmod +x "$dest"
    echo "done."
  else
    echo "failed!"
    exit 1
  fi
}

echo "starting downloads..."
for src in "${!files_to_download[@]}"; do
  url="$base_url/$src"
  dest="$tmpscripts_dir/${files_to_download[$src]}"
  download_file "$url" "$dest"
done

echo "all downloads complete!"
echo "scripts available in: $tmpscripts_dir"
