#! /usr/bin/sh 

numberOfCheckedFiles=1
numberOfFilesToBeChecked=0

for audiofile in *
do
	file -b "$audiofile"|egrep -i "audio|mp4|mpeg|flac|wav|m4a|aac|aiff|media|matroska|3gp|opus|wmv|ape|dts|wavpack|vorbis|ogg" > /dev/null
	isAudio=$?
	if [ $isAudio -eq 0 ]
	then
		numberOfFilesToBeChecked=$((numberOfFilesToBeChecked + 1))
	fi
done

if [ $numberOfFilesToBeChecked -eq 0 ]
then
	echo "There are no files with audio streams in this directory"
	exit 1 
fi

for audiofile in *
do
	# "audio" should cover roughly all files 
	file -b "$audiofile"|egrep -i "audio|mp4|mpeg|flac|wav|m4a|aac|aiff|media|matroska|3gp|opus|wmv" > /dev/null 
	 
	# Get the return status of the last command.
	# If it's non-zero, indicating that the expression was not matched in the search, skip the file.
	isAudio=$?
	if [ $isAudio -eq 0 ]
	then
		echo "$numberOfCheckedFiles/$numberOfFilesToBeChecked. spek '$audiofile'"
		spek "$audiofile" 2> /dev/null # OPTIONAL AND NOT RECOMMENDED: Append an ampersand (&) hereto to perform all checks concurrently 
		numberOfCheckedFiles=$((numberOfCheckedFiles + 1))
	fi
done

#echo "\nDONE!"
