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
	TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$TIMESTAMP - PDF file downloaded, size $fileSize kb" >> $LOGFILE
        pdftotext -layout -q -nopgbrk $INPUT_FILE
	if [ -s $DIR/data/input_*.txt ]; then
		mv $DIR/data/input_*.txt $DIR/data/$2
		lineCount=$(wc -l < $DIR/data/$2)
		echo "$TIMESTAMP - Converted PDF to $lineCount lines of text, saved to $2" >> $LOGFILE
		rm -f $INPUT_FILE
	else
		echo "$TIMESTAMP - Problem downloading $1, $INPUTFILE" >> $LOGFILE
	fi
    else
        echo "$TIMESTAMP - Empty PDF file downloaded, cleaning up and exiting..." >> $LOGFILE
        rm -f $INPUT_FILE
    fi
}

getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2017/defaulters-list1-june2017.pdf june_1_2017.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2017/defaulters-list1-march2017.pdf march_1_2017.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2016/defaulters-list1-december2016.pdf december_1_2016.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2016/defaulters-list1-september2016.pdf september_1_2016.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2016/defaulters-list1-june2016.pdf june_1_2016.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2016/defaulters-list1-march2016.pdf march_1_2016.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2015/defaulters-list1-december2015.pdf december_1_2015.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2015/defaulters-list1-september2015.pdf september_1_2015.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2015/defaulters-list1-june2015.pdf june_1_2015.txt
getPDF http://www.revenue.ie/en/corporate/press-office/list-of-defaulters/2015/defaulters-list1-march2015.pdf march_1_2015.txt
