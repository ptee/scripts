#!/bin/bash
#
# ##############################################################################
# @desc To rename prefix of jpg files in the given directory. 
#       This helps us to find relevant image from their meaningful prefix in 
#       photo collections.
# @author Pattreeya Tanisaro
# ##############################################################################

if [[ $# -ne 3 ]]; then
    echo "To rename jpg files in directory"
    echo "usage: ${0##*/} new_string old_string directory"
    echo "example: ${0##*/} Graz _MG ~/Pictures/Graz/web"
    exit 1
fi

old_string=$2
new_string=$1

cd $3

for f in *.[jJ][pP][gG]
do
    old_name=${f##*/} #filename..(to show how to get basename or using $f instead)
    new_name=${old_name//$old_string/$new_string}
    if [ ! -w $f ]; then
	   echo "warning ...$f is not writable "
    else
	   mv $f $new_name
	   echo "renaming ... $old_name ->  $new_name"
    fi
done
##############################END OF FILE#####################################
