#! /usr/bin/zsh 
# For some reason this script doesn't work with bash, but I honestly don't care because zsh is my favourite shell anyway

cd "$PWD" # With this, the script need not be copied to the working directory 

numberOfCheckedFiles=1
numberOfFilesToBeChecked=0
for file in *; do
	file -b $file|egrep -i "audio|mp4|mpeg|flac|wav|m4a|aac|aiff|media|matroska|3gp|opus|wmv" &> /dev/null
	if [[ $? -eq 0 ]]; then
		numberOfFilesToBeChecked=$((numberOfFilesToBeChecked + 1))
	fi
done

if [[ $numberOfFilesToBeChecked -eq 0 ]]; then
	echo "There are no files with audio streams in this directory" 2>&1
	exit 1 
fi

for file in *; do
	file -b $file|egrep -i "audio|mp4|mpeg|flac|wav|m4a|aac|aiff|media|matroska|3gp|opus|wmv" &> /dev/null 
	# "audio" should cover roughly all files, but some encoders don't embed the right file signatures (see https://en.wikipedia.org/wiki/List_of_file_signatures), which, I think, the file program uses to determine the file type.
	 
	isAudio=$? # Get the return status of the last command. If it's non-zero, indicating that the expression was not matched in the search, skip the file.
	if [[ isAudio -eq 0 ]]; then
		echo "$numberOfCheckedFiles/$numberOfFilesToBeChecked. Running Spek on '$file'" 1>&1
		spek $file 2> /dev/null # OPTIONAL AND NOT RECOMMENDED: Append an ampersand (&) hereto to perform all checks concurrently 
		numberOfCheckedFiles=$((numberOfCheckedFiles + 1))
	fi
done

#echo "\nDONE!"
