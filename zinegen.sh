#!/usr/bin/env bash

# set defaults

DIR_OUT=./build
CSS_PATH=./custom.css

# get options

while getopts o:s: flag
do
    case "${flag}" in
        o) DIR_OUT=${OPTARG};;
        s) CSS_PATH=${OPTARG};;
    esac
done

# remove flags so arg list is only input files
shift $((OPTIND - 1))

# set up build dir and artifacts dir

if [ ! -d $DIR_OUT ]; then
  mkdir $DIR_OUT
fi

if [ ! -d $DIR_OUT/temp ]; then
  mkdir $DIR_OUT/temp
fi

# Clean artifacts and output from previous runs

rm -f $DIR_OUT/temp/*
rm -f $DIR_OUT/output.pdf


ARGS=("$@")
FILES=${ARGS[@]}

for FILE in $FILES
do

	FILENAME=$(basename -- "$FILE")
	FILENAME="${FILENAME%.*}"

	pandoc -o "$DIR_OUT/temp/$FILENAME.pdf" "$FILE" \
		-s -f markdown --pdf-engine=weasyprint \
		--pdf-engine-opt="--stylesheet=$CSS_PATH"

done

psjoin $DIR_OUT/temp/* > $DIR_OUT/temp/joined.pdf
qpdf $DIR_OUT/temp/joined.pdf --pages . 4,3,2,1,5-8 -- $DIR_OUT/temp/reordered.pdf
qpdf --rotate=+180:1-4 $DIR_OUT/temp/reordered.pdf $DIR_OUT/temp/flipped.pdf --flatten-rotation
psnup -p A4 -8 $DIR_OUT/temp/flipped.pdf $DIR_OUT/output.pdf

# clean up build artifacts
rm -r $DIR_OUT/temp