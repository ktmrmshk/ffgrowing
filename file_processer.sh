#!/bin/bash

PROG_DIR=/home/kitamura/fftest
DROPBOX_DIR=/data/GrowingDocumentary_Dropbox
WORKING_DIR=$DROPBOX_DIR/.tmp
DSTDIR=/data/GrowingDocumentary_CONV

FF264=$PROG_DIR/ff264.sh
QTFAST=$PROG_DIR/qt-faststart
MOVEXT="*.mp4 *.MP4 *.mov *.MOV"
MULTIPROCESS=OFF
PROC_LOCK_PREFIX=".inproc_fileproc"
PROC_LOCK_FILENAME=$PROC_LOCK_PREFIX.$$




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
if [ ! -d $WORKING_DIR ]; then
	echo "[log]: mkdir $WORKING_DIR"
	mkdir -p $WORKING_DIR
fi

#mkdir if there isn't $DSTDIR
if [ ! -d $DSTDIR ]; then
	echo "[log]: mkdir $DSTRIR"
	mkdir -p $DSTDIR
fi

#if [ -e ${PROC_LOCK}* ]; then
if [ $MULTIPROCESS = "OFF" ]; then
	if [ `ls -a $WORKING_DIR |grep $PROC_LOCK_PREFIX |wc -l` != 0 ]; then
		echo "already processing ... "
		exit 1
	fi
fi

#make process lock file
touch $WORKING_DIR/$PROC_LOCK_FILENAME


#enter the dropbox dir
cd $DROPBOX_DIR

echo "DEBUG: pwd=" `pwd`
echo `ls -la`

#transcode by files 
for F in $MOVEXT
do
	if [ -e $F ]; then
		#check lock file
		if [ ! -e $WORKING_DIR/${F}.lock ]; then

			echo "processing $F"

			#lock the file
			touch $WORKING_DIR/${F}.lock

			#check if the transfer was done
			SIZE1=`wc -c $F | awk '{print $1}'`
			echo "SIZE1 = $SIZE1"
			sleep 1
			SIZE2=`wc -c $F | awk '{print $1}'`
			echo "SIZE2 = $SIZE2"

			if [ $SIZE1 = $SIZE2 ]; then

				COMMAND="mv $F $WORKING_DIR"
				echo "$COMMAND"
				$COMMAND

				COMMAND="$FF264 $WORKING_DIR/$F $F $WORKING_DIR/${F/.*/_1280x720_tc.mov}"

				#VFOPT1="drawtext=fontfile=/usr/share/fonts/liberation/LiberationMono-Regular.ttf: timecode='00\:00\:00\:00': r=23.98: x=(w-2*tw)/4: y=h-(3*lh): fontcolor=white: box=0: fontsize=40: box=1: boxcolor=black@0.6"
				#VFOPT2="drawtext=fontfile=/usr/share/fonts/liberation/LiberationMono-Regular.ttf: text='${F/.*/}': x=(w-2*tw)/4: y=h-(1.5*lh): fontcolor=white: box=0: fontsize=40: box=1: boxcolor=black@0.6"
				#COMMAND="ffmpeg -i $WORKING_DIR/$F -vcodec libx264 -vprofile baseline -b:v 2400k -s 1280x720 -acodec aac -strict experimental -ab 128k -vf \"$VFOPT1, $VFOPT2\" $WORKING_DIR/${F/.*/_1280x720_tc.mov}"
				echo "$COMMAND"
				$COMMAND

				COMMAND="$QTFAST $WORKING_DIR/${F/.*/_1280x720_tc.mov} $WORKING_DIR/${F/.*/_1280x720_tc_fs.mov}"
				echo "$COMMAND"
				$COMMAND

				COMMAND="rm $WORKING_DIR/${F/.*/_1280x720_tc.mov}"
				echo "$COMMAND"
				$COMMAND

				COMMAND="mv $WORKING_DIR/${F/.*/_1280x720_tc_fs.mov} $DSTDIR"
				echo "$COMMAND"
				$COMMAND

				COMMAND="mv $WORKING_DIR/$F  $DSTDIR"
				echo "$COMMAND"
				$COMMAND


			else

				echo "file $F is now trasferring..."

			fi

			#mv $F $DSTDIR/
			rm $WORKING_DIR/${F}.lock

		else
			echo "other process grab the $F"
		fi
	fi
done





#rm process lock file
rm $WORKING_DIR/$PROC_LOCK_FILENAME

exit 1





