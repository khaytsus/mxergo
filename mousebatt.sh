#!/bin/sh

# Simple script to notify when our battery is low.  Notifies once a day,
# resetting at midnight.  Run this every hour.  If it does not run at
# midnight, make sure to update the code that resets NOTIFIED so that
# you'll be reminded once a day if the battery is still low.

# Requirements
#  Using Unifying Receiver
#  solaar - For reading battery levels

# Optional Requirements
#  mail - For sending mail on the local machine to notify on low battery
#  curl - For using a URL for notification of low battery

# TODO
#  Historical log
#   Keep 'history' out of the vars file and instead log separately
#   Could potentially write something to estimate battery life based on data in log

# You must create this file with your personal settings in it, an example file
# is provided.  Make sure the name is as below, or update the file path below.
settingsfile="${HOME}/.mousebatt.settings"

# If we can't load our settings file, we have to abort
if [ -e ${settingsfile} ]; then
    source ${settingsfile}
else
    echo "Error:  Could not find ${settingsfile}"
    exit
fi

# If you want to maintain a log file, perhaps to do analysis on, set this variable
logfile="${HOME}/.mousebatt.log"

# This file persists some data.  Currently only NOTIFIED is really used but in the
# future we could do cool stuff with the dates or collect other data.  This file
# will be created if it does not exist.
datafile="${HOME}/.mousebatt.vars"

LASTFULLDATE=""
LASTLOWDATE=""
CURRENTLEVEL=""
LASTKNOWNLEVEL=""
CURRENTDATE=""
NOTIFIED=0

if [ -e ${datafile} ]; then
    source ${datafile}
fi

# Write data to file
writedata () {
echo "export LASTFULLDATE=\"${LASTFULLDATE}\"" >${datafile}
echo "export LASTLOWDATE=\"${LASTLOWDATE}\"" >>${datafile}
echo "export CURRENTLEVEL=\"${CURRENTLEVEL}\"" >>${datafile}
echo "export LASTKNOWNLEVEL=\"${LASTKNOWNLEVEL}\"" >>${datafile}
echo "export CURRENTDATE=\"${CURRENTDATE}\"" >>${datafile}
echo "export NOTIFIED=\"${NOTIFIED}\"" >>${datafile}
}

# Log historical data to a file for future analysis
logdata () {
    if [ "${logfile}" != "" ]; then
        epoch=`date +"%s"`
        line="${CURRENTDATE},${epoch},${CURRENTLEVEL}"
        echo ${line} >> ${logfile}
    fi
}

# Set current date
CURRENTDATE=`date`

# Get the current battery percentage info from solaar
battery=`solaar show "${device}" | grep Battery | cut -f 2 -d ":"`

# If we see discharging, get the current percent
if [[ ${battery} =~ ^.*discharging.*$ ]]; then
    CURRENTLEVEL=`echo ${battery} | cut -f 1 -d "," | sed -e 's/[\ \%]//g'`
    LASTKNOWNLEVEL=${CURRENTLEVEL}
    logdata
fi

# If it's unknown, it likely means it's offline and we can't do much
if [[ ${battery} =~ ^.*unknown.*$ ]]; then
    echo "Device is offline"
    CURRENTLEVEL="Offline"
    writedata
    exit
fi

# If we're below the threshold, test if we should notify
if [ ${CURRENTLEVEL} -le ${minbatt} ]; then
    LASTLOWDATE=`date`

    # Determine if we need to reset our notification
    testdate=`date +"%H:%M"`
    if [[ ${testdate} =~ ^00:0.$ ]]; then
        NOTIFIED=0
    fi

    # If NOTIFIED is not set to 1, send out notification(s)
    if [ ${NOTIFIED} -eq 0 ]; then
    	# If an email is set, email it
    	if [ "${notifyemail}" != "" ]; then
        	echo "Sending notification to ${notifyemail}"
	        echo "Low battery detected on ${device}.  Current level is ${CURRENTLEVEL} and minimum allowed is ${minbatt}" \ |
        	    mail -s "Low battery detected on ${device}" ${notifyemail}
            NOTIFIED=1
    	fi

    	# If a url is set, curl it
    	if [ "${notifyurl}" != "" ]; then
    		echo "Curling ${notifyurl}"
            curl ${notifyurl}
            NOTIFIED=1
    	fi
    else
        echo "Already notified"
    fi
else
    # If we're above the threshold, set NOTIFIED to 0
    NOTIFIED=0
fi

# If the battery is full, set the last full date
if [ ${CURRENTLEVEL} -eq 100 ]; then
    LASTFULLDATE=`date`
fi

echo "Current batttery percent: ${CURRENTLEVEL}%"

writedata
