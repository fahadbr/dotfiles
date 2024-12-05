
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

# allow press and hold in vscode
#defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
#defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
#defaults write com.facebook.fbvscode ApplePressAndHoldEnabled -bool false

# allow press and hold globally
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# make the dock hide faster
defaults write com.apple.dock autohide-delay -float 0; killall dock
defaults write com.apple.dock autohide-time-modifier -float 0.2; killall Dock

# update key repeat rate (requires reboot)
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

# opening and closing windows and popovers
#defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# smooth scrolling
#defaults write -g NSScrollAnimationEnabled -bool false

# showing and hiding sheets, resizing preference windows, zooming windows
# float 0 doesn't work
#defaults write -g NSWindowResizeTime -float 0.001

# opening and closing Quick Look windows
#defaults write -g QLPanelAnimationDuration -float 0

# rubberband scrolling (doesn't affect web views)
#defaults write -g NSScrollViewRubberbanding -bool false

# resizing windows before and after showing the version browser
# also disabled by NSWindowResizeTime -float 0.001
#defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false

# showing a toolbar or menu bar in full screen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# scrolling column views
#defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0

# showing and hiding Mission Control, command+numbers
defaults write com.apple.dock expose-animation-duration -float 0

# showing and hiding Launchpad
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0

# changing pages in Launchpad
#defaults write com.apple.dock springboard-page-duration -float 0

# at least AnimateInfoPanes
#defaults write com.apple.finder DisableAllAnimations -bool true

# sending messages and opening windows for replies
#defaults write com.apple.Mail DisableSendAnimations -bool true
#defaults write com.apple.Mail DisableReplyAnimations -bool true
