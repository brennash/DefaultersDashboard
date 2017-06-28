#################################################################
#								#
# download-data.sh						#
#								#
# BASH script to download the defaulters PDF files and convert  #
# the PDFs to text for later processing.			#
#								#
# Version 0.1							#
#################################################################

#!/bin/bash
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$(dirname "$BIN")"
LOGFILE="$DIR/log/pdf-download.log"

# Start the backup
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "$TIMESTAMP - Starting scraping Script.">> $LOGFILE

# File date prefix
DATE=$(date +"%Y%m%d")

# Input file
INPUT_FILE=$DIR/data/input_$DATE.pdf

# Function to download and conver the PDFs
getPDF () {
    wget --quiet $1 -O $INPUT_FILE
    fileSize=$(du -k "$INPUT_FILE" | cut -f 1)

    if [ -s $INPUT_FILE ]; then
        echo "$TIMESTAMP - PDF file downloaded, size $fileSize kb" >> $LOGFILE
        pdftotext -layout -q -nopgbrk $INPUT_FILE
	# mv $DIR/data/*.txt $DIR/data/$2
        # lineCount=$(wc -l < $DIR/data/$2)
        # echo "$TIMESTAMP - Converted PDF to $lineCount lines of text, saved to $2"
        rm -f $INPUT_FILE
    else
        echo "$TIMESTAMP - Empty PDF file downloaded, cleaning up and exiting..." >> $LOGFILE
        rm -f $INPUT_FILE
    fi
}

getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2017/defaulters-list1-june2017.pdf june_2017.txt
