#!/bin/bash

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

export rsync_opts="-avEPc --delete --exclude .git"
export GPG_TTY=$(tty)