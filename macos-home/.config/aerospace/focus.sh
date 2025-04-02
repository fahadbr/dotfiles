#!/usr/bin/env bash

focus_cat="$1"
machine=$(zsh -l -c 'echo $MACHINE')
aerospace_cfg_dir="${HOME}/.config/aerospace"
scratch="${aerospace_cfg_dir}/scratch.sh"

case "$focus_cat" in
  message)
    if [ "$machine" = "work" ]; then
      wid=$(aerospace list-windows --monitor all --app-bundle-id 'com.citrix.receiver.icaviewer.mac' | awk '/IB - / {print $1}' | head -n 1)
      aerospace focus --window-id $wid
    else
      $scratch com.apple.MobileSMS Messages
    fi
    ;;
  browser)
    if [ "$machine" = "work" ]; then
      browser_app='Firefox'
      browser_bundle='org.mozilla.firefox'
    else
      browser_app='Safari'
      browser_bundle='com.apple.Safari'
    fi
    browser_wid="$(aerospace list-windows --workspace focused --app-bundle-id $browser_bundle --format '%{window-id}' | head -n 1)"
    if [[ $browser_wid ]]; then
      aerospace focus --window-id $browser_wid
    else
      open -a "$browser_app"
    fi
    ;;
  notes)
    if [ "$machine" = "work" ]; then
      $scratch 'md.obsidian' 'Obsidian'
    else
      $scratch 'com.apple.Notes' 'Notes'
    fi
    ;;
  calendar)
    open -a 'Calendar'
    ;;
  terminal)
    term_windowid="$(aerospace list-windows --workspace focused --app-bundle-id 'net.kovidgoyal.kitty' --format '%{window-id}')"
    if [[ $term_windowid ]]; then
      aerospace focus --window-id $term_windowid
    else
      open -a 'kitty'
    fi
    ;;
  mail)
    if [ "$machine" = "work" ]; then
      wid=$(aerospace list-windows --monitor all --app-bundle-id 'com.citrix.receiver.icaviewer.mac' | awk '/MSG/ {print $1}')
      aerospace focus --window-id $wid
    else
      open -a 'Mail'
    fi
    ;;
  bbfunction)
    open 'bbg://screens/'
    ;;
  todo)
      $scratch 'com.TickTick.task.mac' 'TickTick'
    ;;
  *)
    ;;

esac

