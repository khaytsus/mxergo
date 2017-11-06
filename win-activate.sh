#!/bin/sh

# Activate windows in an application and if necessary move the mouse
# to that location in the middle of the window.  Inteded to be used
# as a non-interactive script, such as tied to a mouse button, but
# includes a small amount of informational output if ran in a shell.

windowname=$*

export DISPLAY=:0

# Get the first visible window matching this name
window=`xdotool search --onlyvisible --name "${windowname}" | head -1`

# Make sure the window seems valid
if [ ${window} -eq ${window} ] && [ "${window}" != "" ]; then
    echo "Valid window ${window} found"
else
    echo "No valid window for ${windowname} was found"
    exit
fi

# Get the current mouse coordinates
mousex=`xdotool getmouselocation | cut -f 1 -d " " | cut -f 2 -d ":"`
mousey=`xdotool getmouselocation | cut -f 2 -d " " | cut -f 2 -d ":"`

# Get the application bounding area
 windowtop=`xdotool getwindowgeometry ${window} | grep Position | cut -f 2 -d ":" | cut -f 2 -d " " | cut -f 2 -d ","`
windowleft=`xdotool getwindowgeometry ${window} | grep Position | cut -f 2 -d ":" | cut -f 2 -d " " | cut -f 1 -d ","`
 windowwidth=`xdotool getwindowgeometry ${window} | grep Geometry | cut -f 2 -d ":" | cut -f 2 -d " " | cut -f 1 -d "x"`
windowheight=`xdotool getwindowgeometry ${window} | grep Geometry | cut -f 2 -d ":" | cut -f 2 -d " " | cut -f 2 -d "x"`
 windowright=$((windowleft+windowwidth))
windowbottom=$((windowheight+windowtop))

# Determine if the mouse is outside of the window
move=0
if [ ${mousex} -lt ${windowleft} ] || [ ${mousex} -gt ${windowright} ]; then
    move=1
fi

if [ ${mousey} -lt ${windowtop} ] || [ ${mousey} -gt ${windowbottom} ]; then
    move=1
fi

# Activate and focus the window
echo "Activating and focusing on ${window} for ${windowname}"
xdotool windowactivate ${window}
xdotool windowfocus ${window}

# If we need to move the mouse, move it to the middle of the window
if [ ${move} -eq 1 ]; then
    newmousex=$(((windowwidth/2)+windowleft))
    newmousey=$(((windowheight/2)+windowtop))
    echo "Moving mouse to ${newmousex},${newmousey}"
    xdotool mousemove ${newmousex} ${newmousey}
    # Small work-around to make sure mousemove works
    xdotool mousemove_relative 1 1
fi