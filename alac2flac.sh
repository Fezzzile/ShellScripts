#! /usr/bin/zsh

# Convert Apple Lossless Audio Codec (ALAC) to Free Lossless Audio Codec (FLAC).

# This script assumes the ALAC files are in one directory and, therefore, takes no arguments.

# It is the user's duty to confirm that the M4A contains an ALAC file, not AAC.
# In most cases, lossy-to-lossless compression is not ideal.

for track in *m4a
do
	ffmpeg -i "$track" "${track/%m4a/flac}"
done

# Remove M4A-specific tags
for tag in {minor_version,major_brand,compatible_brands}
do
	metaflac --remove-tag="$tag" *flac
done
