#!/bin/bash
# ============================================================================
# Onyx 8 - Autostart Script
# ============================================================================

# Compositor (for transparency and animations)
picom --daemon &

# Set wallpaper
feh --bg-fill ~/.config/qtile/wallpaper.jpg &

# Network Manager applet
nm-applet &

# Notification daemon
dunst &

# Clipboard manager
clipit &

# PolicyKit agent (for GUI auth prompts)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
