#!/bin/bash

export DISPLAY=:0

# xdtotool moves it to the right location visually, but upon moving it's wrong, so
# doing silly workaround below to move the mouse relatively after moving it absolutely

arg=$1

# If we're trying to move left/right, figure out where we are and need to go
if [ "$arg" == "left" ] || [ "$arg" == "right" ]; then
    # Get the current mouse position
    mouseloc=`xdotool getmouselocation | cut -f 1 -d " " | cut -f 2 -d ":"`

    # 3840 is the rightmost of monitor one
    if [ $mouseloc -le 3840 ]; then
        monitor=1
    # 6740 is the leftmost of monitor three, so this logic means I'm on monitor two
    elif [ $mouseloc -le 6740 ]; then
        monitor=2
    # 6740 is the leftmost of monitor three, so here I am verifying I'm on monitor three
    elif [ $mouseloc -gt 6740 ]; then
        monitor=3
    fi

    # Simple right/left movement switches to next/prev monitor.  Note the logic to wrap around.
    if [ "$arg" == "right" ]; then
        arg=$((monitor+1))
        if [ $arg -eq 4 ]; then
            arg=1
        fi
    fi

    if [ "$arg" == "left" ]; then
        arg=$((monitor-1))
        if [ $arg -eq 0 ]; then
            arg=3
        fi
    fi
fi

echo "monitor: [$monitor] arg: $arg"

case $arg in
[1]*)
  xdotool mousemove --sync 1920 600
  xdotool mousemove_relative 1 1
  ;;
[2]*)
  xdotool mousemove --sync 5300 820   # 1.5 scaled in xrandr
  xdotool mousemove_relative 1 1
  ;;
[3]*)
  xdotool mousemove --sync 8500 1100    # 1.5 scaled in xrandr
  xdotool mousemove_relative 1 1
  ;;
esac