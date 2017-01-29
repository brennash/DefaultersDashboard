#!/usr/bin/env python
import math
import sys
import json
import os
import datetime
import time
import re
import datetime
import unicodedata
import collections
from Debtor import Debtor
from sets import Set
from xlrd import open_workbook
from optparse import OptionParser

class ReadExcel:

	def __init__(self):
		# The list of files
		self.files = []

	def parseFile(self, excelFilename):
		jsonList    = []
		workbook    = open_workbook(excelFilename)
		sheet_names = workbook.sheet_names()
		sheet       = workbook.sheet_by_index(0)
		prevLine    = None
		header      = None
		self.files.append(excelFilename)
		jsonList    = self.readDataAsJson(sheet)
	
		for element in jsonList:
			print element

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
					jsonDict[headerValue] = details[index]
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

#			for col in range(sheet.ncols):
#				cellValue   = sheet.cell(row,col).value
#				cleanedText = self.cleanText(cellValue)
#				if cleanedText.lower() == 'name':
#					offense = prevValues[0]
#					header  = sheet.row(row)
#				values.append(cleanedText)
#
#			if values[0].lower() == 'name' and values[1].lower == 'address':
#				header = row
#			else:
#				if values[0] != 'offense' and values[0].lower() != 'name' and len(values[1]) > 1:
#					values.append(offense)
#					
#					print values, header
#					jsonDict = {}
#
#					if header is not None:
#						print values, header
#
#					#	for index, element in enumerate(header):
#					#		if len(element) > 0:
#					#			jsonDict[element] = values[index]
#					#	jsonList.append(json.dumps(jsonDict))
#				
#		return jsonList
#
#

	def asJSON(self, header, offence, valueList):
		jsonDict = collections.OrderedDict()
		errors   = 0

		if header is not None:
			nameIndex              = header.index('name')
			addrIndex              = header.index('address')
			fineIndex              = header.index('fine amount')
			sentenceIndex          = header.index('sentence imposed')
			occIndex               = header.index('occupation')
			jsonDict['name']       = valueList[nameIndex]
			jsonDict['occupation'] = valueList[occIndex]

			if 'county' in header:
				countyIndex = header.index('county')
				jsonDict['address']    = valueList[addrIndex] + ' ' + valueList[countyIndex]
			else:
				jsonDict['address']    = valueList[addrIndex]

			if 'fine' in header:
				fineIndex = header.index
		else:
			jsonDict['name']       = valueList[0]
			jsonDict['address']    = valueList[1]
			jsonDict['occupation'] = valueList[2]
			jsonDict['fine']       = valueList[3]
			jsonDict['sentence']   = valueList[4]
			
		jsonStr = json.dumps(jsonDict, ensure_ascii=True)
		return jsonStr

	def printDebtors(self):
		for debtor in self.debtorList:
			debtor.printDetails()

#	def isHeader(self, valueList):
#		if len(valueList) > 4 and valueList[0].lower() != 'name' and valueList[1] != '':
#			return True
#		return False

	def cleanText(self, inputText):
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


	def processXLSX(self, excelFilename):

		# Read in the Excel file workbook
		workbook  = openpyxl.load_workbook(excelFilename, data_only=True)

		# Only evaluate the top worksheet
		worksheet = workbook.worksheets[0]

		rowLimit = worksheet.max_row
		for x in xrange(1, rowLimit):
			if worksheet.cell(row=x, column=1).value is not None:
				data1 = worksheet.cell(row=x, column=1).value
				print data1

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
