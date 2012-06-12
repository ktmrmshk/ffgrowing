#!/bin/bash

LOCAL_DIR="/data/KMD UCSD collaboration documentary/_FILE_SHARED"
REMOTE_DIR="_FILE_SHARED"

#LOCAL_DIR2="/data/KMD UCSD collaboration documentary/Digital Distribution"
#REMOTE_DIR2="Digital Distribution"


FTP_SERVER="67.58.35.229"

LOCK="$LOCAL_DIR/.file_sharing"


if [ -f "$LOCK" ];then
	echo "other file_sharing.sh  process running ..."
	exit 0;
fi

touch "$LOCK"

echo "pull from remote server ... [$LOCAL_DIR <==> $REMOTE_DIR]"

#LFTP_COMMAND=""
lftp -u collaboration,documentary "$FTP_SERVER" <<END
mirror -np  "$REMOTE_DIR"  "$LOCAL_DIR"
mirror -nRp "$LOCAL_DIR"  "$REMOTE_DIR"
END
echo "done ... [$LOCAL_DIR <==> $REMOTE_DIR]"

#echo "pull from remote server ... [$LOCAL_DIR2 <==> $REMOTE_DIR2]"
#LFTP_COMMAND=""
#lftp -u collaboration,documentary "$FTP_SERVER" <<END
#mirror -np  "$REMOTE_DIR2"  "$LOCAL_DIR2"
#mirror -nRp "$LOCAL_DIR2"  "$REMOTE_DIR2"
#END
#echo "done ... [$LOCAL_DIR2 <==> $REMOTE_DIR2]"


#echo "push to remote server"

rm "$LOCK"

