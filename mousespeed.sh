#!/bin/sh

DISPLAY=:0

# Go ahead and make sure xbindkeys is running
xbindkeys

# USB Unified Receiver for MX Ergo
xinput --set-prop "pointer:Logitech MX Ergo" 'libinput Accel Speed' -.3
xinput --set-prop "pointer:Logitech MX Ergo" 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 .6

# USB Trackman Marble
xinput --set-prop 10 'libinput Accel Speed' 0
xinput --set-prop 10 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 .3
