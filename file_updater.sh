#!/bin/bash

PARAMFILE=$1
. "$PARAMFILE"
#. /home/kitamura/fftest/params.sh



UP_PROC_LOCK_PREFIX=".proc_updater"
UP_PROC_LOCK_FILENAME=$UP_PROC_LOCK_PREFIX.$$



if [ `ls -a "$RECVDIR" |grep "$UP_PROC_LOCK_PREFIX" |wc -l` != 0 ]; then
	echo "The other FileUpdater proess runnnig ..."
	exit 1
fi

touch "$RECVDIR"/$UP_PROC_LOCK_FILENAME

cd "$RECVDIR"

for F in ./*
do
	if [ -e "$F" ]; then
		
		#check lock file
		if [ ! -e "$RECVDIR/${F}.lock" ];then
			echo "transfering $F"

			touch "$RECVDIR/${F}.lock"

			#check if the transfer was done
			SIZE1=`wc -c "$F" | awk '{print $1}'`
			echo "SIZE1 = $SIZE1"
			sleep 1
			SIZE2=`wc -c "$F" | awk '{print $1}'`
			echo "SIZE2 = $SIZE2"

			if [ $SIZE1 = $SIZE2 ]; then
	
				echo "$RECVDIR/$F" "$DONEDIR/$F"
        #mv file to local CONV dir
				mv "$RECVDIR/$F" "$DONEDIR/$F"
				
			else

				echo "file $F is not ready..."

			fi

			rm "$RECVDIR/${F}.lock"

		fi
	fi
done


rm "$RECVDIR"/$UP_PROC_LOCK_FILENAME

