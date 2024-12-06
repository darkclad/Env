#!/bin/bash

printHdrArrow "Set site LC"

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

if [ -z $U01 ]; then
	export U01=~
fi

export SITE=LC
export BLD_DIR=TUX22164
