#!/usr/bin/env python
import sys
import csv
import os
import datetime
import re
import unicodedata
import collections
from optparse import OptionParser

class CleanText:

	def __init__(self, inputFilename):

		inputFile = open(inputFilename, 'rb')
		for line in inputFile:
			if self.validLine(line):
				print line


	def validLine(self, inputLine):
		if '   ' in inputLine:
			inputRegex = re.compile('^[A-Z0-9,&\' ]+$')
			if inputRegex.match(inputLine):
				return True
		return False

def main(argv):
	parser = OptionParser(usage="Usage: CleanText <input-filename>")

        parser.add_option("-v", "--verbose",
                action="store_true",
                dest="verboseFlag",
                default=False,
                help="Verbose output from the script")

	(options, filename) = parser.parse_args()

	if len(filename) != 1 or not os.path.isfile(filename[0]) :
		print parser.print_help()
		exit(1)

	cleanText = CleanText(filename[0])

if __name__ == "__main__":
    sys.exit(main(sys.argv))
