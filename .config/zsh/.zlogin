#!/bin/zsh
if [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland >/dev/null 2>&1
fi
