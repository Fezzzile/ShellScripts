#! /usr/bin/bash

# This is just a simple script to rename all JPEG files in a directory
# I'll soon write a better version in C that will rename any file with EXIF metadata (e.g. DNG, NEF, HEIC)
# The script is helpful when one wants to organise thousands of EXIF-tagged photos

# Say My_lovely_cat.jpg was taken on 13 May 2012 (at 13:47:02)
# Its new name will be IMG_20120513_134702.jpg, which likely is its orginal name.
# Pictures named in this format are easier to organise. 
# One can thereafter easily move all pictures taken in 2012 to a directory named 2012/, with the command "mv IMG_2012* 2012/"

#TODO
#If name exists, check if md5sum checksum is the same. If it is, replace; else append number.
#Remove "Create Date" tag. Can be deceiving.

# To be renamed to renameMedia, also include sort() function by moving to appropriate date directory (first check if directory exists)

for media in *{jfi,JFI,jfif,JFIF,jif,JIF,jpe,JPE,jpeg,JPEG,jpg,JPG} 
do
	date_and_time=$(exiftool -d "%Y%m%d_%H%M%S" "$media"|egrep -i "Create Date|Date/Time Original"|head -n1|cut -d ":" -f2|cut -d " " -f2) 
	# "Create Date" should cover most files. 
	# Some systems, however, only store the "Date/Time Original" field.

	new_name="$date_and_time"".jpg"
	
	if test -e "$new_name"
	then
		echo "$new_name" already exists. Skipping...
		continue
	else 
		if [ "$new_name" = ".jpg" ] # Blank EXIF metadata
		then
			if test -e "$media" # It's obvious the file exists
					# But without this test, say only pics with the .jpg extension exist, 
					# all the other extensions will be echoed here ("'*JPG' does not... Skipping...")
			then
				echo \'"$media"\' does not seem to have EXIF metadata. Skipping...
			fi
			continue # Without this line, pictures with no EXIF metadata will be overwritten, that is, deleted.
		fi

		mv -v "$media" "$new_name"
	fi

done 2>/dev/null # Ignore "Error: File not found - *[file extension]" output 
