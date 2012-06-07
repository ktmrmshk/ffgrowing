#!/bin/bash

LOCAL_DIR="/Users/kitamura/gitdir/ffgrowing/_FILE_SHARED"
REMOTE_DIR="/data/KMD UCSD collaboration documentary/_FILE_SHARED"

FTP_SERVER="137.110.119.195"

echo "pull from remote server ..."

#LFTP_COMMAND=""
lftp -u collaboration,documentary "$FTP_SERVER" <<END
mirror -np  "$REMOTE_DIR"  "$LOCAL_DIR"
mirror -nRp "$LOCAL_DIR"  "$REMOTE_DIR"
END

#echo "push to remote server"



