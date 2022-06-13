# fractional scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# debind the super key
gsettings set org.gnome.mutter overlay-key ''

# disable automatic software update download
gsettings set org.gnome.software download-updates false

# keyboard repeat rate and delay
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
gsettings set org.gnome.desktop.peripherals.keyboard delay 200

# keybindings for moving windows to corners of the screen
gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Super>c']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super><Shift>l']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super><Shift>h']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super><Shift>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super><Shift>j']"
