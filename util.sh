#!/bin/bash

# -------------------------------------------------------------
# Functions
# -------------------------------------------------------------

_load_env() {
	if [ -f $1 ]; then
		printHdrArrow "Setting $2 environment"
		. $1
	else
		print "$1 does not exits. Creating"
		touch $1
	fi
}

printHdr()
{
	echo -e "-------------- $* --------------"
}

printHdrArrow()
{
	echo -e "-------------> $*"
}

print()
{
	echo -e "$*"
}

printDivider()
{
	echo "--------------------------------------"
}

printBanner()
{
  printDivider
  print "$*"
  printDivider
}

printWarning()
{
	print
	printDivider
	printHdr "WARNING. $1"
	printDivider
	print
}

onError()
{
	if [ $1 != 0 ]; then
		print $2
		return $1
	fi
}

makeDir()
{
	for dd in "$@"; do
		if [[ ! -d $dd ]]; then
			mkdir -p $dd > /dev/null
			onError $? "Error. Failed to create directory $dd"
		fi
	done
}

removeDir()
{
	for dd in "$@"; do
		if [[ "$dd" == "/" ]]; then
			onError 1 "Invalid directory to remove %dd"
		fi
		if [[ -d $dd ]]; then
			rm -rf $dd > /dev/null
			onError $? "Error. Failed to create directory $dd"
		fi
	done
}

rpwd()
{
	_pwd=`pwd`
	echo `realpath --relative-to=$MYROOT $_pwd`
}

changeDir()
{
	if [ ! -d $1 ]; then
		onError 1 "Directory $1 does not exits"
	fi
	print "Set directory to `realpath --relative-to=$MYROOT $1`"
	cd $1
}

doCopy()
{
	cp -rf $1 $2 >/dev/null
	onError $? "Failed to copy $1 to $2"
}

onCompileError()
{
	if [ $1 != 0 ]; then
		_logfile=$3
		if [ ! -f $_logfile ]; then
			_logfile="`pwd`/$3"
		fi
		if [ "$2" = "y" ]; then
			cat $_logfile
			print "Build failed. Log file $_logfile"
			print "Environment:"
			print "PATH = [$PATH]"
			print "LD_LIBRARY_PATH=[$LD_LIBRARY_PATH]"
		else
			print "\n$4 build failed. Check the $_logfile file for errors"
		fi
		return $1
	fi
}

setLogFile()
{
  export _LOG_FILE=$1
  print "Set log file to `pwd`/$_LOG_FILE"
  rm -f $_LOG_FILE 2>&1 1>/dev/null
}

if [ -z $_util_loaded ]; then
	printHdrArrow "Utility functions loaded"
	export _util_loaded=1
fi
