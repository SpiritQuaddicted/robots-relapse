#!/bin/bash
# Downloads robots.txt files from the daily top 1 million sites in Alexa's toplist
# Written by Spirit, 20110617ff, do what you want with it

# Downloads to ./files/a/archiveteam.org/YYYYMMDD
# Stores input and log files in ./meta/
# Temporary files will be inside your current directory

# TODO: Remove first empty line in the domain list
# ARGH: Why does aria2c download some files as gzipped data? Wget does not do this. Examples are chinaren.com, sohu.com

# ARGH: The domains come without subdomains, so it might be a good idea to download the www.$domain/robots.txt instead or in addition. Without www. I got ~7500/10000, with www. I got 7800/10000
# YAY:  If downloading 100k use this for checking how many files you got down: find files/*/*/20110628 -print0 | xargs -0 ls -l | wc -l
# takes 300min to download 100k
# takes 60min to 7z 100k

today=$(date +%Y%m%d) #20110621
echo "Downloading download list"
	mkdir -pv files
	mkdir -pv meta
	aria2c http://s3.amazonaws.com/alexa-static/top-1m.csv.zip # download the alexa top domain list
	unzip -o top-1m.csv.zip # overwrites without asking
	
	### using the whole list, aria2c will use >3GB RAM when loading the download list, so let us just get 10000 domains... :}
	### 100000 might work with 3GB
	### 10000 domains usually got be around 7500 robots.txt files down.
	head -n 100 top-1m.csv > temp
	awk 'FS="," {print $2}' temp > domains #remove the "top X number" from before the domain
	rm temp
	rm -v top-1m.csv
	mv -v top-1m.csv.zip meta/top-1m.csv-$today.zip # store today's list for science

echo "Preparing download list"
	rm -vf aria2c_download_list # remove old file, if exists
	
	# using a url input file for aria2c so we can run parellel downloads. This is kinda ugly but works.
	while read domain ; do
		firstletter=${domain:0:1} #first letter of the domain
		echo "http://$domain/robots.txt" >> aria2c_download_list
		echo "  dir=files/$firstletter/$domain" >> aria2c_download_list
		echo "  out=$today" >> aria2c_download_list
	done < domains

echo "Downloading..."
	aria2c --max-concurrent-downloads=12 --connect-timeout=5 --max-tries=2 --remote-time=true --allow-overwrite=true --on-download-complete=verifydownloadedfile.sh --log-level=notice --log=meta/aria2c-$today.log -i aria2c_download_list
	ls -1 files/*/*/$today | wc -l
	echo "files were downloaded"

# 10000 takes about 25 minutes on my 6mbit/s home connection.

# more cleanup
rm aria2c_download_list
rm domains

