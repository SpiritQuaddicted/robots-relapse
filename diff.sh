#!/bin/bash
## todo
## diff between the latest two files per domain
## if just one file, check age. no idea what to do then

#yesterday=$(date +%Y%m%d -d yesterday)
#today=$(date +%Y%m%d)
yesterday=20110626
today=20110627

# https://webigniter.wordpress.com/2011/06/14/list-directories-in-current-directory-using-bash/
directory=~/ramdisk/files/


cd ${directory}
for letter in $(echo */); do
	
	cd ${directory}/${letter}/
	for domain in $(echo */); do
		cd ${directory}/${letter}/${domain}/
		#pwd # = domain
		result=$(diff -q $yesterday $today 2>&1) # 2>&1 so we get stderr ("no such file...") errors in $result too 
		# results of interest are either 
		# files that are new or gone:
		# diff: 20110626: No such file or directory
		# files that were changed:
		# Files 20110626 and 20110627 differ
		# otherwise $result is empty
		if [[ ${result} == "" ]]; then
			true # do nothing
			#echo ${result}
		else
			#echo ${result}
			if $(echo "${result}" | grep -q "No such file or directory") ; then
				#echo ${result} |grep --color=auto "No such"
				echo ${domain} ${result}
			elif $(echo "${result}" | grep -q "differ") ; then
			 	#echo ${result} | grep -E --color=auto '[0-9]{8}'
				echo ${domain} ${result}
				file $yesterday
				file $today
			else
				echo "error error error!" ${domain} ${result} # this should not happen but it would be interesting if
			fi
		fi
	done
done

## crap: files/m/mail.qip.ru/~Inbox