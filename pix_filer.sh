#!/bin/bash

TRANCODED_DIR="/Volumes/dav/_MOV_CONV"
PIX_DIR="/Volumes/dav/_MOV_CONV/.PIX_UPLOADED"
#TRANCODED_DIR="/Users/kitamura/gitdir/ffgrowing/testmov"
#PIX_DIR="/Users/kitamura/gitdir/ffgrowing/pix_uploaded"

#for pix server
PIX_PROJECT="Growing Documentary"
PIX_DST_DIR="/Growing Documentary/_MOV_CONV"

PIX_UPLOADED_DIR="$PIX_DIR"

#mkdir if needed
if [ ! -d "$PIX_UPLOADED_DIR" ];then
	echo "mkdir $PIX_UPLOADED_DIR"
	mkdir -p "$PIX_UPLOADED_DIR"
fi


#copy files to pix_dir from trascoded
for F in $TRANCODED_DIR/*_1280x720_tc_fs.mov
do

	echo "---- $F"
	
	F_NAME="${F##*/}"
	DONE_F_NAME="${F_NAME%.mov}_uploaded.mov"
	
	#DEBUG
	#echo "donefile $DONE_F_NAME"

	if [ ! -f "$PIX_UPLOADED_DIR/$DONE_F_NAME" ]; then
		#echo "cp $F $PIX_DIR/$F_NAME"
		#cp "$F" "$PIX_UPLOADED_DIR/$DONE_F_NAME"
		echo "touch $PIX_UPLOADED_DIR/$DONE_F_NAME"
		touch "$PIX_UPLOADED_DIR/$DONE_F_NAME"
		
		echo "uploading to pix...."
		echo "pixcli -u mkitamura -P $PIX_PROJECT --upload $PIX_DST_DIR $PIX_UPLOADED_DIR/$DONE_F_NAME"
		pixcli -u mkitamura -P "$PIX_PROJECT" --upload "$PIX_DST_DIR" "$F"
		

	fi

done



