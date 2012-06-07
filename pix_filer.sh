#!/bin/bash

TRANCODED_DIR="/home/kitamura/fftest/testmov1"
PIX_DIR="/home/kitamura/fftest/testpix"
PIX_UPLOADED_DIR="$PIX_DIR"

#mkdir if needed
if [ ! -d "$PIX_UPLOADED_DIR" ];then
	echo "mkdir $PIX_UPLOADED_DIR"
	mkdir -p "$PIX_UPLOADED_DIR"
fi


#copy files to pix_dir from trascoded
for F in "$TRANCODED_DIR"/*_1280x720_tc_fs.mov
do

	echo "---- $F"
	
	F_NAME="${F##*/}"
	DONE_F_NAME="${F_NAME%.mov}_uploaded.mov"
	
	#DEBUG
	#echo "donefile $DONE_F_NAME"

	if [ ! -f "$PIX_UPLOADED_DIR/$DONE_F_NAME" ]; then
		echo "cp $F $PIX_DIR/$F_NAME"
		cp "$F" "$PIX_UPLOADED_DIR/$DONE_F_NAME"
		
		echo "upload to pix"
		
	fi

done



