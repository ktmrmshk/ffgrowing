#!/bin/bash

FFMPEG=/usr/local/bin/ffmpeg
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

VFOPT1="drawtext=fontfile=/usr/share/fonts/liberation/LiberationMono-Regular.ttf: timecode='00\:00\:00\:00': r=23.98: x=(w-2*tw)/4: y=h-(3*lh): fontcolor=white: box=0: fontsize=40: box=1: boxcolor=black@0.6"

VFOPT2="drawtext=fontfile=/usr/share/fonts/liberation/LiberationMono-Regular.ttf: text='${2/.*/}': x=(w-2*tw)/4: y=h-(1.5*lh): fontcolor=white: box=0: fontsize=40: box=1: boxcolor=black@0.6"


$FFMPEG -i $1 -vcodec libx264 -vprofile baseline -b:v 2400k -s 1280x720 -acodec aac -strict experimental -ab 128k -vf "$VFOPT1, $VFOPT2" $3

#qt-faststart ${1} $2
#rm .${1}
