#! /usr/bin/env sh

for song in *flac
do
	# File systems in UNIX-like systems disallow the forward slash (/),
	# as do DOS-like systems the colon (:) and other characters.
	
	# The AWK command substitues / (ASCII: 0x2f) with ⧸ (UTF8: 0xe2a7b0).
	title=$(metaflac --show-tag=title "$song"|cut -d "=" -f2|awk '{gsub("/", "⧸"); print}')
	
	tracknumber=$(metaflac --export-tags-to=- "$song"|grep -Ei "track=|tracknumber="|cut -d "=" -f2)
	tracktotal=$(metaflac --export-tags-to=- "$song"|grep -Ei "tracktotal|totaltracks="|cut -d "=" -f2)
	
	# Do not hide the file if the tracknumber tag does not exist (". Hello.flac").
	if [ -z $tracknumber ]
	then
		if [ -z "$title" ]
		then
			echo ""$song" does not have a TITLE tag. Skipping..." > /dev/stderr
			continue
		else
			echo ""$song" will be renamed without a TRACKNUMBER / TRACK tag." > /dev/stderr
			mv -nv "$song" "$title"".flac"
			continue
		fi
	fi
	
	# The prepended zeroes ensure that the song titles after the tracknumber
	# start from the same "column",
	# unless, of couse, it's an album with a hundred+ songs,
	# which almost never occurs.
	if [ "$tracktotal" -gt 9 -a "$tracknumber" -lt 10 ]
		then
			newfilename="0""$tracknumber"". ""$title"".flac"	
			mv -nv "$song" "$newfilename"
		else
			newfilename="$tracknumber"". ""$title"".flac"
			mv -nv "$song" "$newfilename"
	fi
done
