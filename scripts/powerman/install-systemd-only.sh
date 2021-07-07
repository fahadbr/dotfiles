#!/bin/bash

cwd=$(pwd)

ln -vsfT $cwd/dimmer.sh $HOME/.local/bin/dimmer
ln -vsfT $cwd/powerman@.service $HOME/.config/systemd/user/powerman@.service
sudo ln -vsfT $cwd/resume-lock@.service /etc/systemd/system/resume-lock@.service

systemctl enable resume-lock@$(logname).service
