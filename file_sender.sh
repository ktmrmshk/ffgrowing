#!/bin/bash

. /home/kitamura/fftest/params.sh

SERVER="67.58.35.229"
USER="collaboration"
PASS="documentary"

#REMOTE_DIR="_MOV_DROP/.recv"
REMOTE_DIR=/data/pmpshare/KMD\ UCSD\ collaboration\ documentary/_MOV_DROP/.recv

TR_PROC_LOCK_PREFIX=".proc_filetransfer"
TR_PROC_LOCK_FILENAME=$TR_PROC_LOCK_PREFIX.$$



if [ `ls -a "$SENDDIR" |grep "$TR_PROC_LOCK_PREFIX" |wc -l` != 0 ]; then
	echo "The other FileTransfer proess runnnig ..."
	exit 1
fi

touch "$SENDDIR"/$TR_PROC_LOCK_FILENAME

cd "$SENDDIR"

for F in ./*
do
	if [ -e "$F" ]; then
		
		#check lock file
		if [ ! -e "$SENDDIR/${F}.lock" ];then
			echo "transfering $F"

			touch "$SENDDIR/${F}.lock"

			#check if the transfer was done
			SIZE1=`wc -c "$F" | awk '{print $1}'`
			echo "SIZE1 = $SIZE1"
			sleep 1
			SIZE2=`wc -c "$F" | awk '{print $1}'`
			echo "SIZE2 = $SIZE2"

			if [ $SIZE1 = $SIZE2 ]; then
				
				#transfer
				lftp -u $USER,$PASS $SERVER <<END
cd "$REMOTE_DIR"
put "$SENDDIR/$F"
chmod 666 "$F"
END
        #mv file to local CONV dir
				mv "$SENDDIR/$F" "$DONEDIR/$F"

			else

				echo "file $F is not ready..."

			fi

			rm "$SENDDIR/${F}.lock"

		fi
	fi
done


rm "$SENDDIR"/$TR_PROC_LOCK_FILENAME

