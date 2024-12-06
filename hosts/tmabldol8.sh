#/usr/bin/bash

set -o pipefail
_curdir=`dirname $BASH_SOURCE`

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

SANITY_DIR="${TUXDIR}/qa/sanity_tests"

#JAVA_HOME=/etc/alternatives/jre_1.8.0/
#JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk/
JAVA_HOME=/etc/alternatives/jre_11_openjdk/

export ORACLE_BASE_DIR=/scratch/app/dvladi/product/19.0.0
export ORACLE_HOME=$ORACLE_BASE_DIR/db
export ORACLE_BASE=/scratch1/app/dvladi
export ORACLE_INC=$ORACLE_HOME/sdk/include

#export ORACLE_SID=orcl
export ORACLE_SID=tuxartdb1
export DBUSER=artims1
export DBPASSWORD=ims1!2024ART


export TUXDIR_22=$TUXDIR
#export TUXDIR_22=/u01/app/dvladi/OraHome_1/tuxedo22.1.0.0.0
export TUXDIR_12=/u01/app/dvladi/OraHome_1/tuxedo12.2.2.0.0

export LIBS_DIR=$BLD_ROOT/libs
export WLS_HOME=/scratch/app/dvladi/product/19.0.0/weblogic/wlserver/server

#TNS_ADMIN=$ORACLE_HOME/network/admin
TNS_ADMIN=$U01/tnsadmin_tuxartdb1
RAT_JAVA_HOME="/etc/alternatives/jre_1.8.0/"

REMOTE_SYNC_DIR=/scratch/dvladi

if [ -z $_env_is_set_site ]; then
	export PATH=$ORACLE_HOME/bin:$PATH
	export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
	export _env_is_set_site=1
fi

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------

alias sedit='nano ~/.ssh/config'
alias ctma='cd $U01/SNA22164/tma_sna'
alias clion='nohup & $U01/clion-2024.2.3/bin/clion.sh'
export rsync_opts="-avEPc --delete --exclude .git"

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

stack_clear_all

cics_sync() {
  rsync $rsync_opts -e ssh art_cics vm9:/home/vagrant/ForDemian/
}

cics_sync_r() {
  rsync $rsync_opts -e ssh vm9:/home/vagrant/ForDemian/art_cics .
}

#if [ -z "$SSH_AUTH_SOCK" ] ; then
#    eval `ssh-agent`
#    ssh-add
#fi

#if [ -z $TMUX ]; then
#  tmux
#fi

