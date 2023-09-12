#/usr/bin/bash



# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

SANITY_DIR="${TUXDIR}/qa/sanity_tests"

JAVA_HOME=/etc/alternatives/jre_1.8.0/
ORACLE_BASE_DIR=oracle/21/client64
ORACLE_BASE=/usr/lib/oracle
ORACLE_HOME=/usr/lib/$ORACLE_BASE_DIR
ORACLE_INC=/usr/include/$ORACLE_BASE_DIR

TNS_ADMIN=$ORACLE_HOME/network/admin
RAT_JAVA_HOME="/etc/alternatives/jre_1.8.0/"

REMOTE_SYNC_DIR=/scratch/dvladi

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

rsync_opts="-P -u -t -a -c -r --links -k --perms -E --exclude .git"

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

findSym()
{
	for filename in *.a; do
		echo $filename
		objdump -t $filename | grep $1
	done
}

dosync() {
  if [ $# -lt 2 ]; then
    echo "Usage: dosync {file|directory} host"
  else
    _host=$1
    shift
    echo
    for _dir in "$@"; do
      echo ------------ Syncing $_dir to $_host
      rsync $rsync_opts -e ssh ~/$_dir $_host:$REMOTE_SYNC_DIR/`dirname $_dir`
    done

  fi
}

dosyncr() {
  if [ $# -lt 2 ]; then
    echo "Usage: dosync {file|directory} host "
  else
    _host=$1
    shift
    echo
    for _dir in "$@"; do
      echo ------------ Syncing $_dir from $_host
      rsync $rsync_opts -e ssh $_host:$REMOTE_SYNC_DIR/$_dir ~/`dirname $_dir`
    done
  fi
}
