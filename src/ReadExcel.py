#!/usr/bin/env python
import math
import sys
import json
import csv
import os
import datetime
import time
import re
import datetime
import unicodedata
import collections
import pandas as pd
from Debtor import Debtor
from sets import Set
from xlrd import open_workbook
from xlrd import biffh
from optparse import OptionParser

class ReadExcel:

	def __init__(self):
		# The list of files
		self.files = []

	def parseFile(self, excelFilename):
		jsonList    = []
		try:
			workbook    = open_workbook(excelFilename)
			sheet_names = workbook.sheet_names()
			sheet       = workbook.sheet_by_index(0)
			jsonList    = self.readDataAsJson(sheet)
	
			for element in jsonList:
				print element
		except biffh.XLRDError, err:
			
			return None

	def readDataAsJson(self, sheet):
		offence     = None
		header      = None
		jsonList    = []

		for rowIndex in range(sheet.nrows):
			if self.isHeader(sheet.row(rowIndex)):
				header = self.getHeader(sheet.row(rowIndex))
			elif self.isOffence(sheet.row(rowIndex)):
				offence = self.getOffence(sheet.row(rowIndex))				
			else:
				details  = [x.value for x in sheet.row(rowIndex)]
				jsonDict = collections.OrderedDict()
				for index, headerValue in enumerate(header):
					cleanData   = self.cleanText(details[index])

					# Remove additional comments
					if 'additional' not in headerValue.lower():
						jsonDict[headerValue] = cleanData

				if len(offence) < 60:
					jsonDict['Offence'] = offence
				jsonList.append(json.dumps(jsonDict))
		return jsonList

	def isHeader(self, row):
		element1 = self.cleanText(row[0].value)
		element2 = self.cleanText(row[1].value)
		if element1.lower() == 'name' and element2.lower() == 'address':
			return True
		return False

	def getHeader(self, valueList):
		resultList = [x.value.lower() for x in valueList]
		# Clean up certain header fields
		for index, value in enumerate(resultList):
			if 'fine amount' in value:
				resultList[index] = 'fine amount'
		return resultList

	def isOffence(self, row):
		if row[0].value.lower() != 'name' and len(row[1].value) == 0:
			return True
		return False

	def getOffence(self, row):
		return self.cleanText(row[0].value)

	def cleanText(self, inputText):
		""" Cleans up a text string and returns an ascii encoded text
		    string as a result.
		"""
		if inputText is None:
			return ''
		elif type(inputText) is unicode:
			stringValue = unicodedata.normalize('NFKD', inputText).encode('ascii','ignore')
			stringValue = stringValue.replace('\n', ' ')
			stringValue = re.sub( '\s+', ' ', stringValue).strip()
			return stringValue
		else:
			stringValue = str(inputText)
			stringValue = stringValue.replace('\n', ' ')
			stringValue = re.sub( '\s+', ' ', stringValue).strip()
			return stringValue

def main(argv):
	parser = OptionParser(usage="Usage: ReadExcelFile <excel-filename>")

        parser.add_option("-v", "--verbose",
                action="store_true",
                dest="verboseFlag",
                default=False,
                help="Verbose output from the script")

	(options, filename) = parser.parse_args()

	if len(filename) != 1 or not os.path.isfile(filename[0]) :
		print parser.print_help()
		exit(1)

	check = ReadExcel()
	jsonString = check.parseFile(filename[0])
	print jsonString
		
if __name__ == "__main__":
    sys.exit(main(sys.argv))
