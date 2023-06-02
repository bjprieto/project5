#!/bin/bash
# getbooks.sh

# Input Quality Control

# address on Gutenberg.org --> check can wget

# quality control: one argument
if ! [[ $# -eq 1 ]]
then
    1>&2 printf 'invalid number of arguments; expected 1, got %d\n' $#
    exit
fi

# quality control: UTF-8 format
if ! $(grep -Eoq 'https://www.gutenberg.org/ebooks/[[:digit:]]+\.txt\.utf-8' $1)
then
    1>&2 printf 'invalid file format; expected at least one web address in plain text UTF-8 format'
    exit
fi


# Effects

# perform downloads

for web in $(cat $1)
do
    # extract temporary file name
    file=$(echo $web | grep -Eo '[[:digit:]]+\.txt\.utf-8')
    printf '%s\n' $file

    # check if file is preexisting
    if ! [[ -f $file ]]
    then

	# download book and extract relevant information
	wget -q $web
        title=$(head -1 $file | sed 's/The Project Gutenberg [Ee]Book of[[:space:]]//; s/\,.\+//; s/[[:space:]]/_/g')
	author=$(grep -E 'Author: ' $file | sed 's/Author: //; s/[[:space:]]/_/g')
	echo $title
	echo $author
    else
	printf 'exists already\n'
    fi
done

# scrub for author, title
# chk book exists in repo
# if not, download in a directory named after author, file name with book title
