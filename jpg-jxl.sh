#! /usr/bin/sh

# Losslessly compress JPEG pictures.
#
# Note: If `--losless_jpeg=1` is passed to cjxl
# but the input file is not a JPEG, possibly a PNG mislabeled as a JPEG in the extension (the Twitter/X Android app does this),
# the file will be encoded,
# and a warning will be sent to stderr.
#
# What is frustrating is the fact that the process will end with exit code 0.
# Now try reconstructing the "JPEG",
# The warning "Warning: could not decode losslessly to JPEG." is sent to stderr.
# Again, with exit code 0.
#
# And when I convert the original JPEG and the JXL to PPM,
# and compare the checksums of the PPMs, the checksums mismatch,
# confirming that the file was converted lossily.
#
# A possible solution is to confirm that the input file is indeed a JPEG
# with ExifTool before compressing (this scripture does not do that, yet).
#
# Perhaps I should write my own encoder and use libjxl directly!

jpg="$1"
argc=$#
jxl="$(echo $jpg|awk '{gsub(".jpg", ".jxl"); print}')"

if [ $argc -lt 1 ]
then
	echo "Usage: \n\t$0 [JPEG file]"
	exit 1
fi

cjxl --quiet --lossless_jpeg=1 "$jpg" "$jxl" && echo -n "Losslessly compressed '$jpg' to '$jxl'"
# Since I ignore the digits after ".", the result is a floor.
# bc: Changing the scale, to reduce the number of digits after ".", massively affects the accuracy.
# I have to read more documentation, but this will do for now.
echo "($(echo "100 * (1 - $(du -b "$jxl"|cut -d "	" -f 1) / $(du -b "$jpg"|cut -d "	" -f 1))"|bc -l|cut -d "." -f1)% smaller)"

# Copy access and modification times from the JPEG
touch --reference="$jpg" "$jxl"
