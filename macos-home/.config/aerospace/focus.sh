#!/usr/bin/env bash

focus_cat="$1"
machine=$(zsh -l -c 'echo $MACHINE')
aerospace_cfg_dir="${HOME}/.config/aerospace"
scratch="${aerospace_cfg_dir}/scratch.sh"

case "$focus_cat" in
  message)
    if [ "$machine" = "work" ]; then
      wid=$(aerospace list-windows --monitor all --app-bundle-id 'com.citrix.receiver.icaviewer.mac' | grep 'IB' | awk '/IB/ {print $1}')
      aerospace focus --window-id $wid
    else
      $scratch com.apple.MobileSMS Messages
    fi
    ;;
  browser)
    if [ "$machine" = "work" ]; then
      open -a 'Google Chrome'
    else
      open -a 'Safari'
    fi
    ;;
  notes)
    if [ "$machine" = "work" ]; then
      $scratch 'com.apple.Notes' 'Notes'
    else
      $scratch 'com.apple.Notes' 'Notes'
    fi
    ;;
  calendar)
    if [ "$machine" = "work" ]; then
      wid=$(aerospace list-windows --monitor all --app-bundle-id 'com.citrix.receiver.icaviewer.mac' | awk '/APPT/ {print $1}')
      aerospace focus --window-id $wid
    else
      open -a 'Calendar'
    fi
    ;;
  terminal)
    open -a 'kitty'
    ;;
  mail)
    if [ "$machine" = "work" ]; then
      wid=$(aerospace list-windows --monitor all --app-bundle-id 'com.citrix.receiver.icaviewer.mac' | awk '/MSG/ {print $1}')
      aerospace focus --window-id $wid
    else
      open -a 'Mail'
    fi
    ;;
  todo)
      $scratch 'com.TickTick.task.mac' 'TickTick'
    ;;
  *)
    ;;

esac

