#/usr/bin/bash

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

SANITY_DIR="${TUXDIR}/qa/sanity_tests"

#JAVA_HOME=/etc/alternatives/jre_1.8.0/
#JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk/
JAVA_HOME=/etc/alternatives/jre_11_openjdk/

export ORACLE_BASE_DIR=/u01/app/dvladi/product/19.0.0
export ORACLE_HOME=$ORACLE_BASE_DIR/db
export ORACLE_BASE=/u01/app/dvladi
export ORACLE_INC=$ORACLE_HOME/sdk/include

#export ORACLE_SID=orcl
export ORACLE_SID=tuxartdb1
export DBUSER=artims1
export DBPASSWORD=ims1!2024ART


export TUXDIR_22=$TUXDIR
#export TUXDIR_22=/u01/app/dvladi/OraHome_1/tuxedo22.1.0.0.0
export TUXDIR_12=/u01/app/dvladi/OraHome_1/tuxedo12.2.2.0.0

export LIBS_DIR=$BLD_ROOT/libs

#TNS_ADMIN=$ORACLE_HOME/network/admin
TNS_ADMIN=$U01/tnsadmin_tuxartdb1
RAT_JAVA_HOME="/etc/alternatives/jre_1.8.0/"

REMOTE_SYNC_DIR=/scratch/dvladi

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
alias ctma='cd $MYHOME/work/SNA22164/tma_sna'
#rsync_opts="-P -u -t -a -c -r --links -k --perms -E --exclude .git"
rsync_opts="-avEPc --delete --exclude .git"
#rsync_opts="-P -u -t -a -c -r --links -k --perms -E --exclude .git"
alias dus='du -h --max-depth=1 . 2>/dev/null | sort -h'

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

. ~/env/stack.sh

stack_clear_all

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
      rsync $rsync_opts -e ssh $U01/$_dir $_host:$REMOTE_SYNC_DIR/`dirname $_dir`
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
      rsync $rsync_opts -e ssh $_host:$REMOTE_SYNC_DIR/$_dir $U01/`dirname $_dir`
    done
  fi
}

tux12() {
  export TUXDIR=$TUXDIR_12
}

tux22() {
  export TUXDIR=$TUXDIR_22
}


cobolMF() {
  cobol_path=$(stack_pop cobol_path PATH)
  cobol_ld=$(stack_pop cobol_ld LD_LIBRARY_PATH)

  stack_push cobol_path "$cobol_path"
  stack_push cobol_ld "$cobol_ld"


  export COBDIR=/opt/microfocus/VisualCOBOL
  export COBCPY=$COBDIR/cpylib

  export PATH=$COBDIR/bin:$cobol_path
  export LD_LIBRARY_PATH=$COBDIR/lib:$cobol_ld
}

cobolIT() {
  cobol_path=$(stack_pop cobol_path PATH)
  cobol_ld=$(stack_pop cobol_ld LD_LIBRARY_PATH)

  stack_push cobol_path "$cobol_path"
  stack_push cobol_ld "$cobol_ld"

  export COBOLIT_LICENSE=/opt/microfocus/citlicense.xml
  export COBDIR=/opt/cobol-it-64
  export COBOLITDIR=$COBDIR

  export PATH=$COBDIR/bin:$cobol_path
  export LD_LIBRARY_PATH=$COBDIR/lib:$cobol_ld
}

cobolNO() {
  cobol_path=$(stack_pop cobol_path PATH)
  cobol_ld=$(stack_pop cobol_ld LD_LIBRARY_PATH)

  stack_push cobol_path "$cobol_path"
  stack_push cobol_ld "$cobol_ld"

  unset COBDIR
  unset COBCPY
  unset COBOLIT_LICENSE
  unset COBOLITDIR

  export PATH=$cobol_path
  export LD_LIBRARY_PATH=$cobol_ld
}

cics_sync() {
  rsync $rsync_opts -e ssh art_cics vm9:/home/vagrant/ForDemian/
}

cics_sync_r() {
  rsync $rsync_opts -e ssh vm9:/home/vagrant/ForDemian/art_cics .
}
