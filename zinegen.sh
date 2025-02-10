#!/usr/bin/env bash

# set defaults

BASE_DIR=.
PORTRAIT=false


# get options

while getopts d:p flag
do
    case "${flag}" in
		d) BASE_DIR=${OPTARG};;
		p) PORTRAIT=true;;
        # o) DIR_OUT=${OPTARG};;
        # s) CSS_PATH=${OPTARG};;
    esac
done

DIR_OUT=$BASE_DIR/build
CSS_PATH=$BASE_DIR/custom.css

printf '\n'
printf 'Generating zine into %s with %s as stylesheet. Portrait mode is %s.' $DIR_OUT $CSS_PATH $PORTRAIT
printf '\n\n'

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

printf 'Rendering pages...'
printf '\n'

for FILE in $FILES
do


	FILENAME=$(basename -- "$FILE")
	FILENAME="${FILENAME%.*}"

	pandoc -o "$DIR_OUT/temp/$FILENAME.pdf" "$FILE" \
		-s -f markdown --template="$BASE_DIR/template.html" --pdf-engine=weasyprint \
		-c $CSS_PATH

	printf '"%s"   ' "$FILENAME"
	printf '\n'
done

printf '\n'

printf 'Joining pages...'
printf '\n'

psjoin $DIR_OUT/temp/*.pdf > $DIR_OUT/temp/joined.pdf

if [ $PORTRAIT == false ]; then
	# qpdf $DIR_OUT/temp/joined.pdf --pages . 4,3,2,1,5-8 -- $DIR_OUT/temp/reordered.pdf
	qpdf --rotate=+180:1 $DIR_OUT/temp/joined.pdf $DIR_OUT/temp/flipped.pdf --flatten-rotation

	printf 'Generating printable PDF...'
	printf '\n\n'

	psnup -p "297mmx210mm" -c -8 $DIR_OUT/temp/flipped.pdf $DIR_OUT/output.pdf
	# qpdf --rotate=-180:1 $DIR_OUT/output.pdf --replace-input --flatten-rotation
else
	qpdf $DIR_OUT/temp/joined.pdf --pages . 4,3,2,1,5-8 -- $DIR_OUT/temp/reordered.pdf
	qpdf --rotate=+180:1 $DIR_OUT/temp/joined.pdf $DIR_OUT/temp/flipped.pdf --flatten-rotation

	printf 'Generating printable PDF...'
	printf '\n\n'

	psnup -p "210mmx297mm" -c -8 $DIR_OUT/temp/flipped.pdf $DIR_OUT/output.pdf
	qpdf --rotate=-90:1 $DIR_OUT/output.pdf --replace-input --flatten-rotation

fi

# clean up build artifacts
rm -r $DIR_OUT/temp

printf '\n'
printf 'Zine generation complete!'
printf '\n'