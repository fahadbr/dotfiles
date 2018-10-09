#!/bin/bash
# this is a work around for when the powerman.rules
# dont work right after a restart
sudo udevadm control --reload-rules && udevadm trigger
