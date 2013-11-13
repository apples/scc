#!/usr/bin/python

import os
import re
import sys


#------------ begin printUsage() ----------------------------------
def printUsage():
        print ' '
        print '     Usage: TimeWRFRun.py <filename>'
        print '                <filename> is the stdout or stderr file'
        print '                obtained by running wrf.  In a parallel'
        print '                run it is typically rsl.error.0000 or  '
        print '                rsl.out.0000'
        print ' '
#------------ end printUsage() ------------------------------------

#------------ begin getArg() --------------------------------------
def getArg():

	# We're expecting one argument - the name of a WRF stdout/stderr file
	# with timings in it.  We'll get the name from the command line and
	# return it to calling routine
	if len(sys.argv) != 2:
		print 'getArg(): Illegal number of arguments'
		printUsage()
		sys.exit(1)

	# So, if we're here, there's exactly one argument.  See if it it's
	# a readable file

	theFile = sys.argv[1]
	if not os.path.isfile(theFile):
		print 'getArg(): Unable to open file: ' + theFile
		printUsage()
		sys.exit(1)

	return theFile
	

#------------ end getArg() ----------------------------------------


# Get the name of the timing file from the command line
timingFileName = getArg()

# Open it and read the lines into a list of lines for processing
fileHandle = open(timingFileName, 'r')

listOfLines = []
for line in fileHandle:
	listOfLines.append(line)

#print listOfLines

# Proceed through the list, accumulating the time, accounting for special
# cases (where the timing for a step also reflects the timing for other things,
# like writing a wrfout file, etc.)
	
numLines = len(listOfLines)
accumulatedTime = 0.0
numTimeSteps = 0
numBadEntries = 0
junkTime = 0.0        # Accumulates miscellaneous times for later subtraction
i = 0
while i < numLines:
	theLine = listOfLines[i]
	if re.search("^Timing for main: time", theLine):
		# Get the timing value out
		theTokens = theLine.split()

		timeToken = theTokens[8]
		# Need to get around spurious ****** entries
		if timeToken != '**********':
			theTime = float(timeToken)
			# If there was some "junk" time from misc operations, go 
			# ahead and subtract that, then reset the junk timer
			if junkTime > 0.0:
				#print 'Subtracting ' + str(junkTime) + ' seconds'
				theTime = theTime - junkTime
				junkTime = 0.0

			accumulatedTime += theTime
			numTimeSteps += 1
		else:
			numBadEntries += 1

	elif re.search("^Timing for Writing wrfout_", theLine):
		theTokens = theLine.split()
		theTime = float(theTokens[7])
		#print 'Will subtract ' + str(theTime) + ' seconds for wrfout writing'
		junkTime += theTime

	elif re.search("^Timing for processing lateral", theLine):
		theTokens = theLine.split()
		theTime = float(theTokens[8])
		#print 'Will subtract ' + str(theTime) + ' seconds for LBC processing'
		junkTime += theTime

	elif re.search("^Timing for Writing restart", theLine):
		theTokens = theLine.split()
		theTime = float(theTokens[7])
		#print 'Will subtract ' + str(theTime) + ' seconds for restart writing'
		junkTime += theTime

	i += 1

print 'Number bad entries:         ' + str(numBadEntries) 
print 'Time spent integrating:     ' + str(accumulatedTime) + ' seconds'
print 'Number of timesteps:        ' + str(numTimeSteps) 
print 'Average time per timestep : ' + str(accumulatedTime/numTimeSteps) + ' seconds'

