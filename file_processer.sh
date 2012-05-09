#!/bin/bash


PARAMFILE=$1
. "$PARAMFILE"


print_val() {
	echo "$1 : " `eval echo '$'$1`
}

echo '---------------'
print_val PROG_DIR
print_val DROPBOX_DIR
print_val WORKING_DIR
print_val DST_DIR
print_val FF264
print_val MOVEXT
print_val MULTIPROCESS
print_val PROC_LOCK_PREFIX
print_val PROC_LOCK_FILENAME
echo -e "---------------\n"


#mkdir if there isn't $WORKING_DIR
if [ ! -d "$WORKING_DIR" ]; then
	echo "[log]: mkdir $WORKING_DIR"
	mkdir -m 777 -p "$WORKING_DIR"
fi

#mkdir if there isn't $DSTDIR
if [ ! -d "$DSTDIR" ]; then
	echo "[log]: mkdir $DSTDIR"
	mkdir -m 777 -p "$DSTDIR"
fi


#mkdir if there isn't $SENDDIR
if [ ! -d "$SENDDIR" ]; then
	echo "[log]: mkdir $SENDDIR"
	mkdir -m 777 -p "$SENDDIR"
fi

#mkdir if there isn't $RECVDIR
if [ ! -d "$RECVDIR" ]; then
	echo "[log]: mkdir $RECVDIR"
	mkdir -m 777 -p "$RECVDIR"
fi

#if [ -e ${PROC_LOCK}* ]; then
if [ "$MULTIPROCESS" = "OFF" ]; then
	if [ `ls -a "$WORKING_DIR" |grep "$PROC_LOCK_PREFIX" |wc -l` != 0 ]; then
		echo "already processing ... "
		exit 1
	fi
fi

#make process lock file
touch "$WORKING_DIR"/$PROC_LOCK_FILENAME


#enter the dropbox dir
cd "$DROPBOX_DIR"


#transcode by files 
for F in $MOVEXT
do
	if [ -e "$F" ]; then
		#check lock file
		if [ ! -e "$WORKING_DIR/${F}.lock" ]; then

			echo "processing $F"

			#lock the file
			touch "$WORKING_DIR/${F}.lock"

			#check if the transfer was done
			SIZE1=`wc -c "$F" | awk '{print $1}'`
			echo "SIZE1 = $SIZE1"
			sleep 1
			SIZE2=`wc -c "$F" | awk '{print $1}'`
			echo "SIZE2 = $SIZE2"

			if [ $SIZE1 = $SIZE2 ]; then

				COMMAND="mv $F $WORKING_DIR"
				echo "$COMMAND"
				mv "$F" "$WORKING_DIR"			

				COMMAND="$FF264 $WORKING_DIR/$F $F $WORKING_DIR/${F/.*/_1280x720_tc.mov}"

				#VFOPT1="drawtext=fontfile=/usr/share/fonts/liberation/LiberationMono-Regular.ttf: timecode='00\:00\:00\:00': r=23.98: x=(w-2*tw)/4: y=h-(3*lh): fontcolor=white: box=0: fontsize=40: box=1: boxcolor=black@0.6"
				#VFOPT2="drawtext=fontfile=/usr/share/fonts/liberation/LiberationMono-Regular.ttf: text='${F/.*/}': x=(w-2*tw)/4: y=h-(1.5*lh): fontcolor=white: box=0: fontsize=40: box=1: boxcolor=black@0.6"
				#COMMAND="ffmpeg -i $WORKING_DIR/$F -vcodec libx264 -vprofile baseline -b:v 2400k -s 1280x720 -acodec aac -strict experimental -ab 128k -vf \"$VFOPT1, $VFOPT2\" $WORKING_DIR/${F/.*/_1280x720_tc.mov}"
				echo "$COMMAND"
				#$COMMAND
				$FF264 "$WORKING_DIR/$F" "$F" "$WORKING_DIR/${F/.*/_1280x720_tc.mov}"
				

				COMMAND="$QTFAST $WORKING_DIR/${F/.*/_1280x720_tc.mov} $WORKING_DIR/${F/.*/_1280x720_tc_fs.mov}"
				echo "$COMMAND"
				$QTFAST "$WORKING_DIR/${F/.*/_1280x720_tc.mov}" "$WORKING_DIR/${F/.*/_1280x720_tc_fs.mov}"

				COMMAND="rm $WORKING_DIR/${F/.*/_1280x720_tc.mov}"
				echo "$COMMAND"
				#$COMMAND
				rm "$WORKING_DIR/${F/.*/_1280x720_tc.mov}"

				echo "chmod 666"
				chmod 666 "$WORKING_DIR/${F/.*/_1280x720_tc_fs.mov}"

				COMMAND="mv $WORKING_DIR/${F/.*/_1280x720_tc_fs.mov} $DSTDIR"
				echo "$COMMAND"
				#$COMMAND
				mv "$WORKING_DIR/${F/.*/_1280x720_tc_fs.mov}" "$DSTDIR"

				COMMAND="mv $WORKING_DIR/$F  $DSTDIR"
				echo "$COMMAND"
				mv "$WORKING_DIR/$F" "$DSTDIR"
				


			else

				echo "file $F is now trasferring..."

			fi

			#mv $F $DSTDIR/
			rm "$WORKING_DIR/${F}.lock"

		else
			echo "other process grab the $F"
		fi
	fi
done





#rm process lock file
rm "$WORKING_DIR/$PROC_LOCK_FILENAME"

exit 1





