MX Ergo scripts for Linux
================

This is a set of scripts and configurations for making good use of an MX Ergo mouse from Logitech in Linux.  These are personalized for me but might be useful information to other people.

### My Setup
First off, I'll describe my setup here so the scripts make more sense.  I have 3 monitors, one is 3840x2160, two is 2880x1620, three is 2880x1800.  Without going into too much detail, one is a 4k monitor and the other two are 2k monitors scaled up by 1.5 using xrandr so resolution etc is reasonable across all three monitors.  

I run terminals on the left, Chrome on the middle, and some amateur radio stuff on the right monitors and I'm often switching back and forth.  I used do this by keyboard but now I can do it using the mouse much faster, thanks to the tilt buttons on the MX Ergo.

Note that I use XFCE and X11.  If you use Wayland you might need to use different tools.

### How I use the MX Ergo
I currently have it set up in the following way
  * Up button cycles through Chrome windows (see chrome-activate.sh below)
  * Down button is TBD, I haven't yet decided what I want to attach to it.
  * Left/right tilt on scroll wheel moves my mouse cursor to the next monitor
    * If I'm on monitor one, it will go to monitor three, or three to one, etc

### Packages needed
Most distributions should package these, but you might need to install them.  
  * xautomation
    * Provides xte, a tool to map a mouse button to an F key using the XTest extension
  * xdotool
    * Provide xdotool and other utilities
  * xinput
    * Sets input device properties, such as acceleration and speed
    * This is a X11 utility provided in the xorg-x11-server-utils package on Fedora, I can not speak for other distros.  This might be installed by default in most distros

### Speed and Acceleration
Using xinput I set my acceleration to -0.3 to give me just a slight amount of acceleration without being annoying.  -1 is no acceleration, 0 is middle, 1 is maximum.  I'm sure there is some mathematical description for how much acceleration each value provides in this range but just remember that -1 is off, 1 is max.  The other thing I set I also can't really explain very well but it is a coordinate system associated with the device which you should get the defaults then adjust the last number to increase the mouse pointer speed.  0 is quite slow, but starting anything above zero (such as 0.1) is the fastest and as you make the number larger from there the mouse speed decreases.

Note that acceleration affects how much the pointer increases speed over time and speed is the raw speed.  I prefer a combination, but I hate too much acceleration as it makes the pointer too twitchy.

First thing to do is run xinput to get the devices on your system, for example I get a list but all I care about is the MX Ergo

⎜   ↳ Logitech MX Ergo                          id=17   [slave  pointer  (2)]

So from this, I know I need to modify device 17.  I then need to see what the default properties are so I can make adjustments from there.  There are quite a few properties, I'm only showing the ones I care about.  Run this in your shell

<pre><code># xinput --list-props 17 'Coordinate Transformation Matrix'
Device 'Logitech MX Ergo':  
        Coordinate Transformation Matrix (155): 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 0.400000  
        libinput Accel Speed (291):     -0.300000</code></pre>

So for this, you can see the I have the speed set to 0.4 and acceleration set to -0.3.  I don't recall the original values but I suggest you don't just use my values and look at yours first to make sure you're using proper starting values.  I do this in my mousespeed.sh script.

### Assigning mouse buttons to F keys
The simplest way to use the extra mouse buttons is to assign them to F keys, which any desktop environment or other tool can use to assign to functions.  I use XFCE but your DE should have similar function.

In the repo you'll find a file, xbindkeysrc, which you should copy to your home directory as .xbindkeysrc or run xbindkeys -f to specify the file to load, this is up to you.  Look at this file to see how it works, but it's documented within the file which button is assigned to which F key.  If you already use some higher F keys for other things you'll need to modify this file a bit.  Note that I used xev to find these values, you can experiment with that yourself if you like, just make sure xbindkeys isn't running or you won't see the proper information.  Run xev, put the mouse in the window and click a button.  You should see the button listed in the output.

### Assigning F keys to scripts
This really depends on your desktop environment, but for XFCE it's in the Keyboard settings, under Application Shortcuts.  Once you get the scripts set up the way you want (test them in the shell) you can assign here.  Make sure xbindkeys is running so when you assign the hotkey you can make sure the mouse is bound to the right keys and immediately be able to use them.

### Scripts I execute with the mouse

#### chrome-activate.sh
This script finds my Chrome browser and cycles through the windows.  I often have 3-4 windows and rather than alt-tab through them trying to find the correct one I have assigned the top/up button on the mouse to do it.  Only caveat is you can't click super fast, wait a short period (100ms is likely fine) between clicks.  This script also moves the mouse to my middle monitor if it's not already there.  Again; this is very specific to my environment but if it's useful to you it can easily be modified for your setup.

#### movemouse.sh
This script is specifically designed for my setup, but if you use multiple monitors it might still be useful to you but you'll need to adjust the values for your monitors which are all specific to mine.  But my setup is documented at the top and in the script it also explains a bit of what's going on so it shouldn't be hard to update.  But basically if you pass 1, 2, or 3 it goes to the respective monitor.  I have this assigned to Control 1, 2, or 3 which moves the mouse to the respective monitor but I don't use this much anymore.  Now I primarily use right/left, which is passed in when I click the mouse scroll wheel right or left.