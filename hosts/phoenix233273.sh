#/usr/bin/bash

set -o pipefail

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------


export ORACLE_BASE_DIR=/scratch/app/dvladi/product/19.0.0
export ORACLE_HOME=$ORACLE_BASE_DIR/db
export ORACLE_BASE=/scratch1/app/dvladi
export ORACLE_INC=$ORACLE_HOME/sdk/include

#export ORACLE_SID=orcl
export ORACLE_SID=tuxartdb1
export DBUSER=artims1
export DBPASSWORD=ims1!2024ART


#TNS_ADMIN=$ORACLE_HOME/network/admin
TNS_ADMIN=$U01/tnsadmin_tuxartdb1
RAT_JAVA_HOME="/etc/alternatives/jre_1.8.0/"

REMOTE_SYNC_DIR=/scratch/dvladi

if [ -z $_env_is_set_site ]; then
	export PATH=$ORACLE_HOME/bin:$ORACLE_BASE_DIR/client_1/bin:$PATH
	export LD_LIBRARY_PATH=$ORACLE_BASE_DIR/client_1/lib:$LD_LIBRARY_PATH
	export _env_is_set_site=1
fi

rsync_opts="--temp-dir=/home/dvladi/tmp -avEPc --exclude .git"


# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------


# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

syncTux() {
  if [ ! -z $1 ]; then 
	rsync $rsync_opts -e ssh $TUXDIR/bin $1
	#rsync $rsync_opts -e ssh $TUXDIR/bin/TMADMSVR $1/bin
	rsync $rsync_opts -e ssh $TUXDIR/lib $1
  else
	echo "syncTux: Desination is not set"
  fi
}


