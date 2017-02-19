#!/bin/bash
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$(dirname "$BIN")"
LOGFILE=$DIR/log/downloads.log

# Clean up the downloaded pdfs
rm -f $DIR/data/pdfs/*.pdf
rm -f $DIR/data/imgs/*.tif
rm -f $DIR/data/txts/*.txt
rm -f $DIR/data/*.png
rm -f $DIR/data/*.txt
rm -f $DIR/log/*.log


