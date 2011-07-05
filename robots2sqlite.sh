#!/bin/bash
sqlite3 robots.db "CREATE TABLE files (id INTEGER PRIMARY KEY, domain TEXT, time INTEGER, content BLOB)"; #TEXT? #comment this after it ran once, no harm if you dont though.
today=$(date +%Y%m%d)
robotsroot=$1

# https://webigniter.wordpress.com/2011/06/14/list-directories-in-current-directory-using-bash/
directory=${robotsroot}/files/

cd ${directory}
for letter in $(echo */); do
	
	cd ${letter}
	for domain in $(echo */); do
		cd ${domain}
		echo $today ${domain}
		if test "$(ls $today)"; then
			filecontent=$(cat $today)
			q="'";sqlite3 ${robotsroot}/robots.db "INSERT INTO files (time, domain, content) VALUES ('${today}', '${domain//\//}', '${filecontent//$q/$q$q}');"
			# trailing / removed from $domain
			# singlequotes quoted in $filecontents
		fi
		cd ..
	done
	cd ..
done

# we are done, so let's remove the original files (after making a backup)
cd ${robotsroot}
7z a meta/files-$today.7z files/*/*/$today && rm -f files/*/*/$today
