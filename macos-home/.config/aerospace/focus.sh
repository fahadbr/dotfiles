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
      notes_windowid=$(aerospace list-windows --monitor all --app-bundle-id 'net.kovidgoyal.kitty' | awk '/notes/ {print $1}')
      aerospace focus --window-id $notes_windowid
    else
      $scratch 'com.apple.Notes' 'Notes'
    fi
    ;;
  calendar)
    open -a 'Calendar'
    ;;
  terminal)
    term_windowid="$(aerospace list-windows --monitor all --app-bundle-id 'net.kovidgoyal.kitty' | awk '!/notes/ {print $1}')"
    aerospace focus --window-id $term_windowid
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
    wid=$(aerospace list-windows --monitor all --app-bundle-id 'com.citrix.receiver.icaviewer.mac' | grep -vE 'MSG|IB|Launchpad')
    if [[ $(echo "$wid" | wc -l) -eq 1 ]]; then
      aerospace focus --window-id ${wid%% *}
    else
      aerospace focus --window-id $(echo "$wid" | choose | cut -d '|' -f 1)
    fi
    ;;
  todo)
      $scratch 'com.TickTick.task.mac' 'TickTick'
    ;;
  *)
    ;;

esac

