#!/bin/bash

SRC_DIR="/Users/kitamura/gitdir/ffgrowing/testmov1"
PIX_PROJECT="Growing Documentary"
PIX_DST_DIR="/Growing Documentary/_Test Files"

for F in $SRC_DIR/*_1280x720_tc_fs.mov
do
	echo $F
	mv $F ${F%.mov}_uploaded.mov
	
	#uploads to pix
	echo "uploading file ${F%.mov}_uploaded.mov";
	echo "pixcli -u mkitamura -P $PIX_PROJECT --upload $PIX_DST_DIR ${F%.mov}_uploaded.mov"
	pixcli -u mkitamura -P "$PIX_PROJECT" --upload "$PIX_DST_DIR" "${F%.mov}_uploaded.mov"
done


