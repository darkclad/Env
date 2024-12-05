#/usr/bin/bash

set -o pipefail

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

JAVA_HOME=/etc/alternatives/jre_11_openjdk/

export ORACLE_BASE_DIR=ORACLE_BASE_DIR_NOT_SET
export ORACLE_HOME=$ORACLE_BASE_DIR/db
export ORACLE_BASE=ORACLE_BASE_NOT_SET
export ORACLE_INC=$ORACLE_HOME/sdk/include

export TUXDIR_22=$TUXDIR
export TUXDIR_12=/u01/app/dvladi/OraHome_1/tuxedo12.2.2.0.0


TNS_ADMIN=$U01/tnsadmin_tuxartdb1
RAT_JAVA_HOME="/etc/alternatives/jre_1.8.0/"

REMOTE_SYNC_DIR=$MYHOME

if [ -z $_env_is_set_site ]; then
	export PATH=$ORACLE_HOME/bin:$ORACLE_BASE_DIR/client_1/bin:$PATH
	export LD_LIBRARY_PATH=$ORACLE_BASE_DIR/client_1/lib:$LD_LIBRARY_PATH
	export _env_is_set_site=1
fi

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------

alias saix='ssh beadev@slc18fic'
alias daix='ssh slc18fic'
alias dcrm='ssh crm1'
alias disp2='xrandr --output Virtual1 --auto --output Virtual2 --auto --scale 2x2 --right-of Virtual1'
alias disp1='xrandr --output Virtual1 --auto'
alias dsol='ssh slc11kmn'
alias sedit='nano ~/.ssh/config'
alias drem='ssh rem1'
alias gowork='ssh -XC wrk1'

unalias cdd
alias cdd='cd $U01/../Downloads'

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------



