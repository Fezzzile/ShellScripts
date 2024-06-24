#! /usr/bin/env sh

# Convert 8-bit PNG files to lossless WebP.

png="$1"
argc=$#
webp="$(echo $png|awk '{gsub(".png", ".webp"); print}')"

if [ $argc -lt 1 ]
then
	echo "Usage: \n\t$0 [PNG file]"
	exit 1
fi

bitdepth=$(exiftool "$png"|grep -i "Bit Depth"|cut -f 2 -d ":"|cut -d " " -f 2)
# WebP does not support colour depths greater than 8.
if [ $bitdepth -gt 8 ]
then
	echo "'$png' not converted: Bit depth not supported. " > /dev/stderr
	# Consider converting your 16-bit PNGs to JPEG XL (which incorporated FLIF, the Free Lossless Image Format).
	exit 1
fi

# Use ImageMagick
convert "$png" -define webp:lossless=true "$webp" && echo -n "Losslessly converted '$png' to '$webp'"
# Since I ignore the digits after ".", the result is a floor.
# bc: Changing the scale, to reduce the number of digits after ".", massively affects the accuracy.
# I have to read more documentation, but this will do for now.
echo "($(echo "100 * (1 - $(du -b "$webp"|cut -d "	" -f 1) / $(du -b "$png"|cut -d "	" -f 1))"|bc -l|cut -d "." -f1)% smaller)"

# Copy modification and access times
# Known issue: this line does not work if the script is invoked with zsh
# (despite the shebang).
touch -r "$png" "$webp"

# Follow the psedocode below to check if the generated WebP is truly lossless.
# ffmpeg -i [PNG file] fromPNG.ppm
# ffmpeg -i [WebP file] fromWebP.ppm
# if checksum(fromPNG.ppm) == checksum(fromWebP.ppm) # checksum can be crc32, md5sum, sha1sum, etc.
# 	WebP is lossless
# else WebP not lossless
# I chose the PPM format because it does not store metadata, which can affect the checksum.

# As far as I know, there is no de-facto standard on how/where to store metadata/tags in PNGs.
# Though ImageMagick keeps the tags during the conversion,
# it is possible that some tags will be lost.
# An alternative solution would be exporting, stripping, and importing the tags with exiftool.
#
# If, like me, you have thousands of screenshots spanning a decade,
# you can convert all of them with the command 'find -type f -iname  "*png" -exec png2webpl \{\} \;'
# and free approximately 50% of the space taken by the PNGs, without any quality loss.
# Using the find command and deleting the PNGs is safe, since, in general, screenshots have an 8-bit colour depth,
# have no metadata and use the sRGB colour space (which need not be embedded in the file).
