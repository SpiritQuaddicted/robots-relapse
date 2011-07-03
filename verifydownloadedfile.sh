#!/bin/sh

# this script is called by aria2c after each finished download.
# http://aria2.sourceforge.net/aria2c.1.html#_event_hook
# the path to the downloaded file is passed as third argument 

# if there is a grep match, remove the file
today=$(date +%Y%m%d) #20110621

if test "$(file $3 | grep -E '(.*data.*|.*empty.*|.*HTML document.*|.*gzip compressed data.*|.*application.*|^PE32 executable.*|.*image data.*)' )"; then
	echo "Removing $3" >> meta/removal-$today.log     
	rm $3
fi
