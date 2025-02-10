#!/usr/bin/env bash

# set defaults

BASE_DIR=.


# get options

while getopts d: flag
do
    case "${flag}" in
		d) BASE_DIR=${OPTARG};;
        # o) DIR_OUT=${OPTARG};;
        # s) CSS_PATH=${OPTARG};;
    esac
done

DIR_OUT=$BASE_DIR/build
CSS_PATH=$BASE_DIR/custom.css


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
		-s -f markdown --template="$BASE_DIR/template.html" --pdf-engine=weasyprint \
		-c $CSS_PATH
	

done

psjoin $DIR_OUT/temp/* > $DIR_OUT/temp/joined.pdf
qpdf $DIR_OUT/temp/joined.pdf --pages . 4,3,2,1,5-8 -- $DIR_OUT/temp/reordered.pdf
qpdf --rotate=+180:1-4 $DIR_OUT/temp/reordered.pdf $DIR_OUT/temp/flipped.pdf --flatten-rotation
psnup -p A4 -8 $DIR_OUT/temp/flipped.pdf $DIR_OUT/output.pdf

# clean up build artifacts
rm -r $DIR_OUT/temp