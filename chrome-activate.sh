#!/bin/sh

# I have 3 monitors, Chrome runs on the middle one.  So I determine if the mouse
# is on that monitor or not by montwo/monthree, browserx/y is where I move the mouse
# to if needed
montwo=3840
monthree=6740
browserx=5300
browsery=820
browser="Google Chrome"

export DISPLAY=:0

# Find our browser window and where our mouse currently is
window=`xdotool search --name "${browser}" | head -1`
mouseloc=`xdotool getmouselocation | cut -f 1 -d " " | cut -f 2 -d ":"`

# Activate the browser window
xdotool windowactivate ${window}
xdotool windowfocus ${window}
rc=$?

# If we're on another monitor, move the mouse there
if [ ${mouseloc} -le ${montwo} ] || [ ${mouseloc} -ge ${monthree} ]; then
    xdotool mousemove ${browserx} ${browsery}
    xdotool mousemove_relative 1 1
fi