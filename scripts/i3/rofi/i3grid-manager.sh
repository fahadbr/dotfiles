#!/usr/bin/env bash

## ---- Rofi Frontend ----
# Currently, the grid resizing is static. If you change it to a different
# number, you **may need to change the height and width correspondingly in the rasi file.
# Control rofi theming here (Deep configuration available in the rasi file)
# Too many env vars will slow down the load time, hence limitation.

## FIXME: Theming
export COLS=3   # Corresponds to grid layout of the screen (X,Y)
export LINES=3
export BG="#000000"                     # Panel Background
export TXT="#bdc3c3"                    # Text color
export GRID_FONT="Iosevka 13"           # Font (Include size)
export ACTIVE="rgba(9, 145, 224, 0.4)"  # Active Cell background
export SBAR="#242222"                   # Search Bar background

## FIXME: Path to the src python3 file/module
grid_src="-m i3grid"
# Uncomment below line if cloned from github
# grid_src="../i3-grid/i3grid"

# Initalize
join() { local IFS="$1"; shift; echo "$*"; }
# Absolute path to script (must be in the same folder as matrix.rasi)
app_abs_path="~/.config/i3grid"
rofi_command="rofi -i -theme $app_abs_path/matrix.rasi -multi-select"
#rofi_command="rofi -i -multi-select"
# We use a bash function to dynamically generate the
# grid for different canvases on the fly.
grid=()
_l=$(( $LINES - 1 ))
_carry=$COLS
# Rofi aligned menu
# rows --> Col transformation (This is why search index is wrong).
# We can make this transformation on the python3 side but speed tradeoff..
for value in $(seq 1 $COLS); do
  grid+=($value)
  for i in $(seq 1 $_l); do
    mew=$(( $value + $_carry ))
    grid+=($mew)
    i=$(( $i + 1 ))
    _carry=$(( $COLS * $i ))
  done
  _carry=$COLS
done
# Custom Commands
grid+=(
  "A" # Apply snap to *all windows in current workspace
  "C" # Custom Percentage, center window (ofc, you can override otf)
  "D" # Use default rc file rows and col nums to create grid and use input as snap target
  "F" # Make a window completely full screen (ignores all offsets)
  "G" # Guake style window
  "H" # Hide all workspace floating windows, if scratchpad
  "R" # Reset to i3 default center (75% screen)
  "SF" # Snaps all current *floating windows into a grid
  "X" # Custom col, row, target parsing

  ## FIXME: Add command here. Define it's call in the case statement below (line 125).
)
options=""
for i in ${grid[*]}; do
  options="${options}${i}\n"
done
# grid options passed to rofi
chosen="$(echo -e "$options" | $rofi_command -dmenu -p "Grid:" -selected-row 0)"
len=${#chosen}
if [[ "$len" -gt "2" ]]; then  # if multi select
  declare -a arr
  arr=( $(echo $chosen | awk '{split($0,a," ")} END {for(n in a){ print a[n] }}') )
  multi_arg=$(join ' ' ${arr[@]})
  python3 $grid_src multi --multis $multi_arg
  exit
elif [[ ! " ${grid[@]} " =~ " ${chosen} " ]]; then
    # Catch non-grid user input
    # Ex: I run raw custom commands that I type into the grid (as outputted by rofi)
    echo "Error: Element Out of grid"
    python3 $grid_src -h
    exit
fi
# Non multi options
# NOTE: These settings are not optimized. The resize function (& others)
#       may be run multiple times if autoresize is also on. Make
#       sure to update the functions in accordance to your config
#       for optimal perfomance (<50ms actions).
case "$chosen" in
"A")
  python3 $grid_src snap --all
;;
"C")
  p="$($rofi_command -dmenu -p "% -" -selected-row 0)"
  python3 $grid_src csize --perc=$p
;;
"D")
  target="$($rofi_command -dmenu -p 'Target:' -selected-row 0)"
  python3 $grid_src snap --target $target
;;
"F")
  python3 $grid_src csize --perc 100
;;
"G")
   python3 $grid_src snap --target 1 --rows 2 --cols 1 --offset 0 80 0 80
;;
"H")
  python3 $grid_src hide --noresize --nofloat --all
;;
"R")
  python3 $grid_src reset
;;
"SF")
  python3 $grid_src snap --floating --rows 3 --cols 2
;;
"X")
  custom="$($rofi_command -dmenu -p "c r t:" -selected-row 0)"
  IFS=' ' read -ra r_c_t <<< "$custom"
  if [[ "${#r_c_t[@]}" != "3" ]]; then
    echo "Incorrect Argument Length (Need Row, Col, Target)"
    exit
  fi
  python3 $grid_src \
    snap  \
    --cols ${r_c_t[0]} --rows ${r_c_t[1]}  \
    --target ${r_c_t[2]}
;;

## FIXME Define custom calls here. Template (Ex: Using custom command 'O'):
# "O")
#   python3 $grid_src <action> <optional-flags>
# ;;

*)
  # Uncomment to see the raw command sent to i3-grid
  # echo "python3 $grid_src float snap --cols $COLS --rows $LINES --target $chosen"
  python3 $grid_src snap --cols $COLS --rows $LINES --target $chosen
;;
esac
