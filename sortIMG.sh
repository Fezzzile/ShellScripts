#! /usr/bin/env sh

argc=$#

if [ $argc -lt 1 ]
then
	echo "Usage: \n\t$0 <yyyymmdd_------.ext>"
	exit
fi

media="$1"
nameprefix=`ls "$media"|cut -d "_" -f 1`
mkdir "$nameprefix"
mv -nv "$media" "$nameprefix"/
