#!/usr/bin/env bash

DIR_OUT=./build
CSS_PATH=./custom.css

while getopts o:s: flag
do
    case "${flag}" in
        o) DIR_OUT=${OPTARG};;
        s) CSS_PATH=${OPTARG};;
    esac
done

shift $((OPTIND - 1))

if [ ! -d $DIR_OUT ]; then
  mkdir $DIR_OUT
fi



ARGS=("$@")
FILES=${ARGS[@]}

rm -f $DIR_OUT/*

for FILE in $FILES
do

	FILENAME=$(basename -- "$FILE")
	FILENAME="${FILENAME%.*}"

	pandoc -o "$DIR_OUT/$FILENAME.pdf" "$FILE" \
		-s -f markdown --pdf-engine=weasyprint \
		--pdf-engine-opt="--stylesheet=$CSS_PATH"

done

psjoin $DIR_OUT/* > $DIR_OUT/joined.pdf
psnup -p A4 -4 $DIR_OUT/joined.pdf $DIR_OUT/checklists.pdf
