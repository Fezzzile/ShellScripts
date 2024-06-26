#! /usr/bin/sh
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# This script is deprecated.
# Re-encoding FLAC to FLAC with reference FLAC encoder (`flac -f audio.flac`)
# addresses the issues outlined below.
#
# From the man in Debian GNU/Linux:
# "flac can also re-encode FLAC files.  
# In other words, you can specify a FLAC or Ogg FLAC file as an input to the encoder
# and it will decoder it and re-encode it according to the options you specify.  
# It will also preserve all the metadata unless you override it with other options
#  (e.g.  specifying new tags, seekpoints, cuesheet, padding, etc.)."
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# This script removes album art, which I don't embed in FLAC files,
# unless the FLAC is a single release.
#
# For albums, I prefer to have a cover art file, "cover.jpg/png",
# in the same directory with all the songs.
# This saves space, since I prefer the highest resolution of a cover art;
# I generally download them from Ben Dodson's iTunes Artwork Finder
# (https://bendodson.com/projects/itunes-artwork-finder/).
#
# The "uncompressed" version is exactly what the label/distributor uploaded 
# to iTunes and/or Apple Music, with all metadata still intact. Nice!
# Some of these files are 16-bit PNGs and TIFFs, taking over 30 MiB.
# When I finally get that 300-inch 8K screen (just kidding) I don't want to
# see any compression artifacts and colour banding. (Actually, I'm not kidding.)
#
# But another reason for the script is to "fix" FLAC files which were encoded
# by crappy encoders, some of which do not store MD5 checksums of the RAW audio.
# I also want to use the highest compression setting.
# The `flac` command, which uses `libflac`, does the job perfectly.
#
# Issues:
# `metaflac`, the metadata handler, does not support importing multi-line tags, such as lyrics,
# from a file; such tags have to be imported from standard input (stdin).

for song in *flac
do
	metaflac "$song" --export-tags-to="$song"".tags"
	flac -d --preserve-modtime "$song" && flac --preserve-modtime -f --best *wav && rm *wav && metaflac "$song" --import-tags-from="$song"".tags" && rm "$song"".tags"
done

# This is decent for now, but it is slowly killing my SSD, since it decodes the FLAC
# to an uncompressed PCM (.wav), and thereafter encodes the PCM to FLAC again.
# A better solution is to use libflac directly and save the PCM in main memory, not to the SSD.
# This way, fewer bytes are written to the SSD, and its lifespan is reduced slightly.
