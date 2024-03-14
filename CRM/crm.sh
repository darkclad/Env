#!/bin/bash

echo --- Set CRM functions ---

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

export TMASNA=$U01/SNA122264/tma_sna

export TM_MIN_PUB_KEY_LENGTH=1024
export TUXNZTRACE=8191

export LIBS_DIR=$BLD_ROOT/libs

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------

alias fsna='nano $TMASNA/log/makesna.log'
alias fcrm='nano $TMASNA/log/makecrm.log'
alias fbase='nano $TMASNA/log/makebase.log'

alias esna='cat $TMASNA/log/makesna.log | grep "error"'
alias ecrm='cat $TMASNA/log/makecrm.log | grep "error"'
alias ebase='cat $TMASNA/log/makebase.log | grep "error"'

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------



ccrm()
{
  cd $U01/CRM/bin
  killall CRM
}

ctma()
{
  cd $TMASNA
}

csnas()
{
 cd $U01/snasnt
 . env.sh
 ./stop.sh
}
