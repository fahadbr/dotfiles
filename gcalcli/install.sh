#!/bin/bash

cwd=$(pwd)
ln -s -v -f $cwd/gcal-reminder.service ~/.config/systemd/user/
ln -s -v -f $cwd/gcal-reminder.timer ~/.config/systemd/user/
