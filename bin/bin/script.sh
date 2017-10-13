#!/bin/sh

wid=$1
class=$2
instance=$3
title=$(xtitle "$wid")

if [ "$instance" = sun-awt-X11-XDialogPeer ] ; then
    echo "state=floating"
    echo "focus=on"
    echo "border=off"
    echo "title $title windid: $wid" > .bspclog

    xdotool windowactivate $wid
    xdotool windowmove $wid 0 0
fi

