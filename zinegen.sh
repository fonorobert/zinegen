#!/usr/bin/env bash

BASEDIR=~/Nextcloud/Documents/checklists
DIR_OUT=$BASEDIR/build
CSS_PATH=$BASEDIR/checklistgen/custom.css

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

pdfjam -o $DIR_OUT/checklists.pdf --nup 2x2 --no-landscape $DIR_OUT/*
