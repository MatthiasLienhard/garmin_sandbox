#!/bin/bash

APP=$1
DEV=$2
if [ -z $DEV ] ;then DEV="vivoactive_hr";fi
KEYS="$HOME/projects/connectiq-sdk-lin-3.0.1"
P_INFO="$HOME/projects/connectiq-sdk-lin-3.0.1/bin/projectInfo.xml"

echo "build $APP for $DEV"
# kill the simulator if it's running
# pkill simulator
#res=""
#for f in $(find $APP/resources/ -name '*.xml'); do res="$res -z $f"; done
# build via monkeyc 
monkeyc -r -y $KEYS/developer_key.der -o $APP.prg -f $APP/monkey.jungle -w -p $P_INFO -r -d $DEV

# launch the simulator, and wait
#connectiq &
#sleep 3

# run the app, as the corresponding device type
#monkeydo $APP.prg $DEV
