#!/bin/bash
# i3 thread: https://faq.i3wm.org/question/150/how-to-launch-a-terminal-from-here/?answer=152#post-id-152

#CMD=urxvt
CMD='kitty --detach'
CWD=''

if [ "$1" = "--new-instance-group" ]
then
  # determine new sessionid
  KITTY_IG=$(date "+%s")
fi

# Get window ID
ID=$(xdpyinfo | grep focus | cut -f4 -d " ")

# Get PID of process whose window this is
PID=$(xprop -id $ID | grep -m 1 PID | cut -d " " -f 3)

# Get last child process (shell, vim, etc)
if [ -n "$PID" ]; then
  #TREE=$(pstree -lpA $PID | tail -n 1)
  #PID=$(echo $TREE | awk -F'---' '{print $NF}' | sed -re 's/[^0-9]//g')
  PID=$(ps --ppid $PID | grep zsh | tail -n 1 | awk '{print $1}')

  # If we find the working directory, run the command in that directory
  if [ -e "/proc/$PID/cwd" ]; then
    CWD=$(readlink /proc/$PID/cwd)
  fi
  if [ -e "/proc/$PID/cmdline" ]; then
    KITTY_IG=$(cat /proc/$PID/cmdline | sed 's/\x00/ /g' | sed -E 's/.*(--instance-group )([a-zA-Z0-9]+).*/\2/g')
  fi

fi
if [ -n "$CWD" ]; then
  #cd $CWD && $CMD
  if [ "$KITTY_IG" ]; then
    kitty --single-instance --detach -d $CWD
  fi
else
  setsid $CMD &
fi
