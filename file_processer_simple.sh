#!/bin/bash

#basically handling file as absolute path

#read param file
PARAMFILE=$1
. "$PARAMFILE"



#functions
print_val() {
	echo "$1 : " `eval echo '$'$1`
}

#### main part from here
#1. lock process

echo "$LOCK"

if [ -e "$LOCK" ];then
	echo "other process's running ..."
	exit 0
else
	touch "$LOCK"
fi



#2. get list of files to be transcoded
for F in $DROPDIR/*.mov $DROPDIR/*.MOV
do
	if [ -e "$F" ]; then

		#3. skip files including "_1280x720_tc_fs" in its file name
		if [[ "$F" =~ "$POSTFIX" ]]; then
			continue;
		fi

		#4. skip files if file of name with "_1280x720_tc_fs" exisits
		FILE_NAME="${F##*/}"
		FILE_PREFIX="${FILE_NAME%.*}"
		FILE_EXT="${FILE_NAME##*.}"
		if [ -e "$DROPDIR/${FILE_PREFIX}${POSTFIX}.mov" ]; then
			continue;
		fi



		#5. check if the transfer was done
		SIZE1=`wc -c "$F" | awk '{print $1}'`
		echo "SIZE1 = $SIZE1"
		sleep 1
		SIZE2=`wc -c "$F" | awk '{print $1}'`
		echo "SIZE2 = $SIZE2"

		if [ $SIZE1 = $SIZE2 ]; then

		#DEBUG
		echo "processing $F ... "

			#6. do ffmpeg transcoding
			COMMAND="$FF264 $F $FILE_PREFIX ${F/.*/_1280x720_tc.mov}"
			echo "$COMMAND"
			#$COMMAND
			$FF264 "$F" "$FILE_PREFIX" "${F/.*/_1280x720_tc.mov}" "$PARAMFILE"

			#7. do qt-fast-ing
			COMMAND="$QTFAST ${F/.*/_1280x720_tc.mov} ${F/.*/$POSTFIX.mov}"
			echo "$COMMAND"
			$QTFAST "${F/.*/_1280x720_tc.mov}" "${F/.*/$POSTFIX.mov}"

			#8. remove temporary file
			COMMAND="rm ${F/.*/_1280x720_tc.mov}"
			echo "$COMMAND"
			#$COMMAND
			rm "${F/.*/_1280x720_tc.mov}"

			#9. chmod for one to rwrite and read
			echo "chmod 666"
			chmod 666 "${F/.*/$POSTFIX.mov}"

		else

			echo "file $F is now trasferring..."

		fi

	fi
done

#rm process lock file
rm "$LOCK"

exit 1
