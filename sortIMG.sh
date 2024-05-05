#!/usr/bin/bash

year=$1
month=$2
day=1

while (( $day <= 31 ))
do
	if (( $day < 10 )); then
		yyyymmdd="$year""$month""0""$day"
	else	
		yyyymmdd="$year""$month""$day"
	fi

	mkdir "$yyyymmdd"
	mv -n "$yyyymmdd"* "$yyyymmdd" #And make sure you don't override existing file
	day=$(($day + 1))
done

# Delete empty directories
rmdir */
