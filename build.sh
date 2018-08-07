#!/bin/bash

APP=$1
DEV=$2
if [ -z $DEV ] ;then DEV="vivoactive_hr";fi
KEYS="$HOME/projects/connectiq-sdk-lin-2.4.8"
P_INFO="$HOME/projects/connectiq-sdk-lin-2.4.8/bin/projectInfo.xml"

echo "build $APP for $DEV"
# kill the simulator if it's running
pkill simulator
res=""
for f in $(find $APP/resources/ -name '*.xml'); do res="$res -z $f"; done
# build via monkeyc 
monkeyc -y $KEYS/developer_key.der -o $APP.prg -m $APP/manifest.xml $res $APP/source/* -w -p $P_INFO -g -d $DEV

# launch the simulator, and wait
connectiq &
sleep 3

# run the app, as the corresponding device type
monkeydo $APP.prg $DEV
