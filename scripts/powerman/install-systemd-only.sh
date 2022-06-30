#!/bin/bash

cwd=$(pwd)

ln -vsfT $cwd/dimmer.sh $HOME/.local/bin/dimmer
ln -vsfT $cwd/watch-sleep.sh $HOME/.local/bin/watch-sleep.sh

ln -vsfT $cwd/sleep.target $HOME/.config/systemd/user/sleep.target
ln -vsfT $cwd/watch-sleep.service $HOME/.config/systemd/user/watch-sleep.service
ln -vsfT $cwd/$servicefile $HOME/.config/systemd/user/powerman@.service
ln -vsfT $cwd/lock.service $HOME/.config/systemd/user/lock.service

systemctl --user daemon-reload
systemctl --user enable --now watch-sleep.service
#systemctl --user enable lock.service
