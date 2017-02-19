#!/bin/bash
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$(dirname "$BIN")"
LOGFILE=$DIR/log/downloads.log

# Use OCR as well as PDFTOTEXT
source $DIR/config/download.cfg

# Now start the download of the files
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "$TIMESTAMP - Downloading the Defaulters Data" >> $LOGFILE
echo "$TIMESTAMP - Downloading the Defaulters Data"
STARTTIME=`date +%s`

downloadPDF () {
	TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
	echo "$TIMESTAMP - Downloading $1 as $2.pdf" >> $LOGFILE
	echo "$TIMESTAMP - Downloading $2.pdf and start processing"
	wget -q $1 -O $DIR/data/pdfs/$2.pdf

	# Convert the PDF using pdftotext
	if [ "$use_pdf_to_text" = true ] ; then
		TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
		echo "$TIMESTAMP - Converting $2.pdf to $2_pdf.txt" >> $LOGFILE
		pdftotext -q -layout $DIR/data/pdfs/$2.pdf $DIR/data/$2_pdf.txt
	fi

	# Convert the PDF using OCR/Tesseract
	if [ "$use_pdf_ocr" = true ] ; then
		TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
		echo "$TIMESTAMP - Converting $2.pdf to PNG image files" >> $LOGFILE
		convert -monochrome -density 300 $DIR/data/pdfs/$2.pdf -resize 50% $DIR/data/pngs/images_%d.png
		# gs -dNOPAUSE -g3000x6000 -dBATCH -o $DIR/data/tiffs/$2-%03d.tif -sDEVICE=tiff32nc -r300x300 $DIR/data/pdfs/$2.pdf > /dev/null 2>&1

		# Count of the pages scanned
		PAGENUM=1

		# Loop to iterate over the scans and do OCR on each.
		for filename in $DIR/data/pngs/*.png; do
			TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
			echo $PAGENUM
			echo "$TIMESTAMP - Processing image file $filename" >> $LOGFILE

			echo "$TIMESTAMP - Creating names image file names_$PAGENUM.png" >> $LOGFILE
			convert -crop 340x1240+0 $filename $DIR/data/names_$PAGENUM.png

#			echo "$TIMESTAMP - Creating addresses image file addresses_$PAGENUM.png" >> $LOGFILE
#			convert -crop 415x1240+340 $filename $DIR/data/addresses_$PAGENUM.png
#
#			echo "$TIMESTAMP - Creating occupations image file page_$SCAN_PAGE_occupations.png" >> $LOGFILE
#			convert -crop 345x1240+755 $filename $DIR/data/page_$SCAN_PAGE_occupations.png
#
#			echo "$TIMESTAMP - Creating fines image file page_$SCAN_PAGE_fines.png" >> $LOGFILE
#			convert -crop 100x1240+1100 $filename $DIR/data/page_$SCAN_PAGE_fines.png

			echo "$TIMESTAMP - Converting these image files to text at $2_names_$PAGENUM" >> $LOGFILE
			tesseract -l eng -c preserve_interword_spaces=1 $DIR/data/names_$PAGENUM.png $DIR/data/txts/$2_names_$PAGENUM /dev/null 2>&1
#			tesseract -l eng -c preserve_interword_spaces=1 $DIR/data/page_$SCAN_PAGE_addresses.png $DIR/data/txts/$2_$SCAN_PAGE_addresses /dev/null 2>&1
#			tesseract -l eng -c preserve_interword_spaces=1 $DIR/data/page_$SCAN_PAGE_occupations.png $DIR/data/txts/$2_$SCAN_PAGE_occupations /dev/null 2>&1
#			tesseract -l eng -c preserve_interword_spaces=1 $DIR/data/page_$SCAN_PAGE_fines.png $DIR/data/txts/$2_$SCAN_PAGE_fines /dev/null 2>&1

			TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
			echo "$TIMESTAMP - Finished processing $2.pdf" >> $LOGFILE
			echo "$TIMESTAMP - Finished processing $2.pdf"
			((PAGENUM++))
		done

		# Now concat the output text files
		# cat $DIR/data/txts/*.txt >> $DIR/data/$2_ocr.txt

		#rm $DIR/data/pngs/*.png
		#rm $DIR/data/*.png
		# rm $DIR/data/txts/*.txt
	fi

	# Clean up the downloaded pdfs
	rm $DIR/data/pdfs/*.pdf

	TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
	echo "$TIMESTAMP - Cleaning up TIFFs and PDFs for $2" >> $LOGFILE
	echo "$TIMESTAMP - Cleaning up TIFFs, TXTs and PDFs for $2, output is in data/$2.txt"
}

downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list1-september2016.pdf Sept2016_1
#downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list2-september2016.pdf Sept2016_2
#downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list1-june2016.pdf June2016_1.pdf
#downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list2-june2016.pdf June2016_2.pdf
#downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list1-march2016.pdf March2016_1.pdf
#downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list2-march2016.pdf March2016_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2015.pdf Dec2015_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2015.pdf Dec2015_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2015.pdf Dec2015_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2015.pdf Dec2015_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-september2015.pdf Sept2015_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-september2015.pdf Sept2015_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2015.pdf June2015_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2015.pdf June2015_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2015.pdf March2015_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2015.pdf March2015_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2014.pdf Dec2014_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2014.pdf Dec2014_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2014.pdf Sept2014_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2014.pdf Sept2014_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2014.pdf June2014_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2014.pdf June2014_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2014.pdf March2014_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2014.pdf March2014_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2013.pdf Dec2013_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2013.pdf Dec2013_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2013.pdf Sept2013_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2013.pdf Sept2013_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2013.pdf June2013_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2013.pdf June2013_2.pdf  
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2013.pdf March2013_1.pdf 
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-2013march.pdf March2013_2.pdf  
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2013a.pdf Dec2012_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2013.pdf Dec2012_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2012.pdf Sept2012_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2012.pdf Sept2012_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2012.pdf June2012_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2012.pdf June2012_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2012.pdf March2012_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2012.pdf March2012_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-mar2012.pdf Dec2011_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-mar2012.pdf Dec2011_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2011.pdf Sept2011_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2011.pdf Sept2011_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2011.pdf June2011_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2011.pdf June2011_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2011.pdf March2011_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2011.pdf March2011_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2011.pdf Dec2010_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2011.pdf Dec2010_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2010.pdf Sept2010_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2010.pdf Sept2010_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2010.pdf	June2010_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2010.pdf June2010_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2010.pdf March2010_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2010.pdf March2010_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2010.pdf Dec2009_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2010.pdf Dec2009_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2009.pdf Sept2009_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2009.pdf Sept2009_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2009.pdf	June2009_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2009.pdf June2009_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2009.pdf March2009_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2009.pdf March2009_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2009.pdf Dec2008_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2009.pdf Dec2008_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2008.pdf	Sept2008_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2008.pdf Sept2008_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def1-september2008.pdf June2008_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def2-september2008.pdf June2008_2.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def1-108.pdf March2008_1.pdf
#downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def2-108.pdf March2008_2.pdf

