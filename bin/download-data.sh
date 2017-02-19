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
		echo "$TIMESTAMP - Converting $2.pdf to TIFF image files" >> $LOGFILE
		convert -density 300 $DIR/data/pdfs/$2.pdf -depth 8 -strip -background white -alpha off $DIR/data/imgs/images_%d.tif
		# convert -density 300 $DIR/data/pdfs/$2.pdf -resize 50% $DIR/data/imgs/images_%d.tif

		# Loop to iterate over the scans and do OCR on each.
		PAGENUM=1
		for filename in $DIR/data/imgs/images_*.tif; do
			TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
			echo "$TIMESTAMP - Processing image file $filename" >> $LOGFILE
			echo "$TIMESTAMP - Creating names image file names_$PAGENUM.tif" >> $LOGFILE
			convert -crop 680x2480+0 $filename $DIR/data/names_$PAGENUM.tif

			echo "$TIMESTAMP - Creating addresses image file addresses_$PAGENUM.tif" >> $LOGFILE
			convert -crop 830x2480+680 $filename $DIR/data/addresses_$PAGENUM.tif

			echo "$TIMESTAMP - Creating occupations image file occupations_$PAGENUM.tif" >> $LOGFILE
			convert -crop 690x2480+1510 $filename $DIR/data/occupations_$PAGENUM.tif

			echo "$TIMESTAMP - Creating fines image file fines_$PAGENUM.tif" >> $LOGFILE
			convert -crop 20x2480+2200 $filename $DIR/data/fines_$PAGENUM.tif

			echo "$TIMESTAMP - Converting these image files to text at $2_names_$PAGENUM" >> $LOGFILE
			tesseract -l eng -c presenve_interword_spaces=1 $DIR/data/names_$PAGENUM.tif $DIR/data/txts/$2_names_$PAGENUM

			echo "$TIMESTAMP - Converting these image files to text at $2_addresses_$PAGENUM" >> $LOGFILE
			tesseract -l eng -c preserve_interword_spaces=1 $DIR/data/addresses_$PAGENUM.tif $DIR/data/txts/$2_addresses_$PAGENUM

			echo "$TIMESTAMP - Converting these image files to text at $2_occupations_$PAGENUM" >> $LOGFILE
			tesseract -l eng -c preserve_interword_spaces=1 $DIR/data/occupations_$PAGENUM.tif $DIR/data/txts/$2_occupations_$PAGENUM

			echo "$TIMESTAMP - Converting these image files to text at $2_fines_$PAGENUM" >> $LOGFILE
			tesseract -l eng -c preserve_interword_spaces=1 $DIR/data/fines_$PAGENUM.tif $DIR/data/txts/$2_fines_$PAGENUM

			TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
			echo "$TIMESTAMP - Finished processing $2.pdf" >> $LOGFILE
			echo "$TIMESTAMP - Finished processing $2.pdf"
			((PAGENUM++))
		done

		# Remove the TIF images
		rm $DIR/data/imgs/*.tif
		rm $DIR/data/*.tif
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

