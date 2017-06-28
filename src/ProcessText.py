import io
import re
import os
import csv
import sys
import time
import datetime
import collections
from sets import Set
from optparse import OptionParser


class ProcessText:

	def __init__(self):
		self.customerList = []
		self.addressList  = []

	def run(self, filename):
		""" 
		"""
		self.readText(filename)

	def readText(self, filename):
		""" 
		Read the CSV file into the list
		"""
		outputList = []

		inputFile        = open(filename, 'rb')
		index            = 0
		
		prevLine         = ''
		currentLine      = ''
		nextLine         = ''


		for line in inputFile:

			prevLine    = currentLine			
			currentLine = nextLine
			nextLine    = line
			





#			name        = line[0:24]
#			address     = line[24:68]
#			profession  = line[68:97]
#			fine        = line[95:110]

			startRegex = re.compile('^\w{1,3}\s{2,20}\w+$')
			endRegex = re.compile('^\w+\s{2,20}\w{1,3}$')

			print fine

			index += 1

def main(argv):
        parser = OptionParser(usage="Usage: ProcessText <text-filename>")
        (options, filename) = parser.parse_args()

	if len(filename) == 1:
		if os.path.exists(filename[0]):
			processor = ProcessText()
			processor.run(filename[0])
		else:
	                parser.print_help()
        	        print '\nYou need to provide an existing input file.'
			exit(1)
	else:
                parser.print_help()
                print '\nYou need to provide existing input file.'
                exit(1)

if __name__ == "__main__":
    sys.exit(main(sys.argv))



