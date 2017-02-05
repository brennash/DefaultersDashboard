#!/bin/bash
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$(dirname "$BIN")"
LOGFILE=$DIR/log/data-downloads.log

# Now start the download of the files
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "$TIMESTAMP - Downloading the Defaulters Data" >> $LOGFILE
STARTTIME=`date +%s`

downloadPDF () {
	wget -q $1 -O $DIR/data/$2
	pdftotext $DIR/data/$2	
	TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
	PDF_SIZE=`ls -lh $2`
	echo "$TIMESTAMP - Downloading $1 and converting to $2, size is $PDF_SIZE" >> $LOGFILE
	rm -f $DIR/data/*.pdf
}

downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list1-september2016.pdf Sept2016_1.pdf
downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list2-september2016.pdf Sept2016_2.pdf
downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list1-june2016.pdf June2016_1.pdf
downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list2-june2016.pdf June2016_2.pdf
downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list1-march2016.pdf March2016_1.pdf
downloadPDF http://www.revenue.ie/en/press/defaulters/defaulters-list2-march2016.pdf March2016_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2015.pdf Dec2015_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2015.pdf Dec2015_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2015.pdf Dec2015_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2015.pdf Dec2015_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-september2015.pdf Sept2015_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-september2015.pdf Sept2015_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2015.pdf June2015_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2015.pdf June2015_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2015.pdf March2015_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2015.pdf March2015_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2014.pdf Dec2014_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2014.pdf Dec2014_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2014.pdf Sept2014_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2014.pdf Sept2014_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2014.pdf June2014_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2014.pdf June2014_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2014.pdf March2014_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2014.pdf March2014_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2013.pdf Dec2013_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2013.pdf Dec2013_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2013.pdf Sept2013_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2013.pdf Sept2013_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2013.pdf June2013_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2013.pdf June2013_2.pdf  
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2013.pdf March2013_1.pdf 
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-2013march.pdf March2013_2.pdf  
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2013a.pdf Dec2012_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2013.pdf Dec2012_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2012.pdf Sept2012_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2012.pdf Sept2012_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2012.pdf June2012_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2012.pdf June2012_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2012.pdf March2012_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2012.pdf March2012_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-mar2012.pdf Dec2011_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-mar2012.pdf Dec2011_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2011.pdf Sept2011_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2011.pdf Sept2011_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2011.pdf June2011_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2011.pdf June2011_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2011.pdf March2011_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2011.pdf March2011_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2011.pdf Dec2010_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2011.pdf Dec2010_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2010.pdf Sept2010_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2010.pdf Sept2010_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2010.pdf	June2010_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2010.pdf June2010_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2010.pdf March2010_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2010.pdf March2010_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2010.pdf Dec2009_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2010.pdf Dec2009_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-dec2009.pdf Sept2009_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-dec2009.pdf Sept2009_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-sept2009.pdf	June2009_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-sept2009.pdf June2009_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-june2009.pdf March2009_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-june2009.pdf March2009_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-march2009.pdf Dec2008_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-march2009.pdf Dec2008_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list1-december2008.pdf	Sept2008_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/defaulters-list2-december2008.pdf Sept2008_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def1-september2008.pdf June2008_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def2-september2008.pdf June2008_2.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def1-108.pdf March2008_1.pdf
downloadPDF http://www.payeanytime.ie/en/press/defaulters/archive/def2-108.pdf March2008_2.pdf

FINISHTIME=`date +%s`
RUNTIME=$((end-start))
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
echo "$TIMESTAMP - Files downloaded in $RUNTIME seconds" >> $LOGFILE
