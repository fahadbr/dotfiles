
# Note: Must re-login to session after changing these

# this enables dragging windows with cmd+ctrl+click
# to disable run:
# defaults delete -g NSWindowShouldDragOnGesture
defaults write -g NSWindowShouldDragOnGesture -bool true

# set up touchid for authenticating sudo
if ! cat /etc/pam.d/sudo | grep -q pam_tid.so; then
	header=$(cat /etc/pam.d/sudo | head -n 1)
	body=$(cat /etc/pam.d/sudo | tail -n +2)
	new_contents="$header\nauth       sufficient     pam_tid.so\n$body"
	echo "$new_contents" | sudo tee /etc/pam.d/sudo
fi
