#!/bin/bash
# rwsl a.k.a Replace With Symbolic Link
# for importing files into this repo and
# placing a symbolic link in their original
# location to this repo

fileName=$1

dir=$(dirname $fileName)
base=$(basename $fileName)

if [[ ! -f $base ]]; then
	mv -n $fileName ./
else
	echo "$fileName already exists"
	exit 1
fi

ln -s $(pwd)/$base $fileName
