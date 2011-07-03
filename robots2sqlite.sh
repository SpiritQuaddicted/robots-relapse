#!/bin/bash
#sqlite3 robots.db "CREATE TABLE files (id INTEGER PRIMARY KEY, domain TEXT, time INTEGER, content BLOB)"; #TEXT?

# this outer loop was for a bigger import of the old data
#dates=( 20110626 20110627 20110628 20110629 20110630 20110701 20110702 )
#for day in "${dates[@]}"
#do

today=$(date +%Y%m%d)

# https://webigniter.wordpress.com/2011/06/14/list-directories-in-current-directory-using-bash/
directory=files/

cd ${directory}
for letter in $(echo */); do
	
	cd ${directory}/${letter}/
	for domain in $(echo */); do
		cd ${directory}/${letter}/${domain}
		echo $today ${domain}
		if test "$(ls $today)"; then
			filecontent=$(cat $today)
			q="'";sqlite3 ../../../robots.db "INSERT INTO files (time, domain, content) VALUES ('${today}', '${domain//\//}', '${filecontent//$q/$q$q}');"
		fi
		# trailing / removed from $domain
		# singlequotes quoted in $filecontents
	done
done
#done
