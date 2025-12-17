#!/bin/zsh
if [ "$(tty)" = "/dev/tty1" ]; then
  # exec start-hyprland >/dev/null 2>&1
  exec hyprland >/dev/null 2>&1
fi
