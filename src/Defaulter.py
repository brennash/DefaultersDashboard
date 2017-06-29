import re

class Defaulter:

	def __init__(self, line):
		self.name         = ''
		self.address      = ''
		self.profession   = ''
		self.sentence     = ''
		self.fine         = 0.0
		self.numCharges   = 0
		self.originalLine = line

		self.setName(line)
		self.setAddress(line)
		self.setProfession(line)

	def update(self, line):

		startIndex = len(line) - len(line.lstrip())
		if '  '  in line[startIndex:]:
			endIndex   = line.index('  ', startIndex)
		else:
			endIndex = len(line)

		if startIndex == 0:
			tokens     = line.split('  ')
			self.name  = self.name + ' ' + line[startIndex:endIndex]
		else:
			if startIndex == self.originalLine.index(self.address):
				self.address  = self.address + ' ' + line[startIndex:endIndex]

	def setName(self, line):
		if line is None or len(line) == 0:
			return None
		else:
			# Get position of contiguous whitespace
			if '  ' in line[0:28]:
				index = line.index('  ')
				self.name = line[0:index]
			else:
				# Otherwise find the most appropriate spacing
				indexList = self.getIndexList(line, ' ')
				validList = []
				for index in indexList:
					if index >= 4 and index <= 25:
						validList.append(index)
				self.name = line[0:validList[-1]].rstrip()

	def setAddress(self, line):
		if len(self.name) == 0 and len(line) > 70:
			self.address = line[18:69].lstrip().rstrip()
		else:
			nameIndex  = len(self.name)
			addressStr = line[nameIndex:].lstrip().rstrip()

			if '  ' in addressStr[0:45]:
				tokens = addressStr.split('  ')
				self.address = tokens[0]
			else:
				indexList = self.getIndexList(addressStr, ' ')
				validList = []
				for index in indexList:
					if index >= 5 and index <= 45:
						validList.append(index)
				self.address = addressStr[0:validList[-1]].rstrip()

	def setProfession(self, line):

		# Only set the profession if a valid name/address is already present
		if self.name != '' and self.address != '':

			# Fine the index position of the address in the string
			index            = line.index(self.address)
			addrLen          = len(self.address)
			professionStr    = line[(index+addrLen):].lstrip().rstrip()

			if '  ' in professionStr:
				tokens = professionStr.split('  ')
				self.profession = tokens[0]
			else:
				indexList = self.getIndexList(professionStr, ' ')
				validList = []
				for index in indexList:
					if index >= 5 and index <= 25:
						validList.append(index)
				self.profession = addressStr[0:validList[-1]].rstrip()


	def getStartIndex(self, line, startIndex):
		charRegex = re.compile('[a-zA-Z0-9]')
		for index, char in enumerate(line[startIndex:]):
			if charRegex.match(char):
				return (index+startIndex)
		return -1

	def getEndIndex(self, line, startIndex):
		shortLine = line[startIndex:]
		if '  ' in shortLine:
			index = shortLine.index('  ')
			return index
		else:
			return -1

	def getName(self):
		return self.name

	def getAddress(self):
		return self.address

	def getProfession(self):
		return self.profession

	def getIndexList(self, line, targetChar):
		""" 
		A helper function which returns the list of indexes (as a list) of a 
		particular character in a string.
		"""
		indexList = []
		for index, char in enumerate(line):
			if char == targetChar:
				indexList.append(index)	
		return indexList
