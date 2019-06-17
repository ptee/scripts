#!/bin/bash
# Project: To convert mp3 to mp4 (with single still image) from a directory and upload these files on youtube.com 
# Note:    email and password must be set explicitely in this file.
# Author:  Pattreeya Tanisaro
# Date:    17.04.2013
# Requirment: 1) ffmpeg with mp3 lib and other codec support
#             2) youtube-upload with 2 extra python libraries ( the requirement shown after installation)
#              README: https://code.google.com/p/youtube-upload/wiki/Readme
#              Checkout: svn checkout http://youtube-upload.googlecode.com/svn/trunk/ youtube-upload
# 
# --------------------------------------------------------------
# FILE="example.tar.gz"
# echo "${FILE%%.*}"   # example
# echo "${FILE%.*}"    # example.tar
# echo "${FILE#*.}"    # tar.gz
# echo "${FILE##*.}"   #gz
#
# --------------------------------------------------------------

############################ Setting ############################
email=dhammafromforest@gmail.com
passwd=xxxxxxxx
#################################################################

if [[ $# -ne 4 ]]; then
    echo "To convert mp3 to mp4 ( with single still image) from a writable folder and upload these files on youtube.com"
    echo "Email and password are set explicitely in this file."
    echo "usage: ${0##*/} mp3_to_mp4_path   abs_png_paths    image_prefix image_extension"
    echo "example: ${0##*/} ~/tmp/mp3    ~/tmp/photos/480x360  AjMartin-  png"
    echo ""
    exit 1
fi

mp3_path=$1
img_path=$2
img_prefix=$3
img_ext=$4



get_image() {
	 RANGE=17 # set range 0..14
	 number=$RANDOM # random is 16bit integer, the actual range is 0 - 32767
	 let "number %= RANGE"
	 imgfile=${img_prefix%.*} # file basename with extension
	 number=`printf "%03d" $number` # fix position of space!! get 001 002..010...
	 imgfile=$imgfile$number.$img_ext
	 echo "image file:  $imgfile"
}

START=$(date +%s)

cd $mp3_path 
cnt=0
for fname in *.[mM][pP]3
do
	 get_image
	 basename=${fname%%.*} #file basename 
	 ffmpeg -loop 1 -f image2 -i ${img_path}${imgfile} -i $fname -c:v libx264 -c:a libvo_aacenc -t 00:05:00.000  $basename.mp4
	 youtube-upload --email=$email --password=$passwd --category=Education --title=$basename $basename.mp4
	 cnt=$(( $cnt + 1 ))
done




END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to process $cnt files in $mp3_path"

################################## end of file ############################
