#!/usr/bin/bash

_mydir=$(realpath $(dirname ${BASH_SOURCE[0]}))
. $_mydir/sites/LC.sh

echo -------------- Setting up the ORACLE environment --------------

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

export SHARED_DRIVE=SHARED_DRIVE_NOT_SET

export BLD_ROOT=$U01/$BLD_DIR
export CRONDIR=$BLD_ROOT/cron

if [ -z $TUXDIR ]; then
export TUXDIR=$BLD_ROOT/$SITE/bld
echo "Set TUXDIR to $TUXDIR"
fi

export THIRD_PARTY_LIB_DIR=$BLD_ROOT/libs

SANITY_DIR="${TUXDIR}/qa/sanity_tests"
export LIBS_DIR=$BLD_ROOT/libs

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------

alias cdb='cd $BLD_ROOT/cron/build'
alias cdl='cd $BLD_ROOT/cron/log'
alias cds='cd $BLD_ROOT/LC/bld'
alias cdt='cd $MYHOME/tmp'
alias cdg='cd $BLD_ROOT/LC/bld/TuxWS/gwws'
alias cdu='cd $U01/'

alias cdqa='cd $BLD_ROOT/LC/bld/qa/sanity_tests/apps'
alias cda='cd $U01/art_ims/cron'
alias cdba='cd $U01/art_batch'
alias ctma='cd $U01/work/SNA22164/tma_sna'

alias cdo='cd $ORACLE_HOME'
alias cdsa='cd $SANITY_DIR'
alias cdj='cd $U01/Jenkins'

alias dsol='ssh slc11kmn'
alias sedit='nano $MYHOME/.ssh/config'
alias drem1='ssh rem1'
alias drem2='ssh rem2'
alias drem3='ssh rem3'
alias saix='ssh beadev@slc18fic'
alias daix='ssh slc18fic'
alias dcrm='ssh crm1'

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

elog()
{
	pushd .
	cdl
	nano $1
	popd
}

flog()
{
	elog build_log
}

slog()
{
	elog salt_log
}

runbuild()
{
	export CRONDIR=$BLD_ROOT/cron
	cd ${BLD_ROOT}/cron/build
	_action=$1
	shift
	if [ "$1" = "d" ]; then
		export DEBUGBUILD=y
		shift
	fi
	./build $_action $*
}

buildcheck()
{
	runbuild buildcheck
}

buildstage()
{
	cat ${BLD_ROOT}/cron/log/build_log | grep "Running: gmake"
}

runsanity()
{
	runbuild runsanity $1
}

dostage()
{
	runbuild stagecheck
}

dobuild()
{
	runbuild do_build $*
}

dotsam()
{
	runbuild tsambuild $*
}

dosalt() {
	runbuild saltbuild $*
}

domake()
{
	export LIBPATH=$ORACLE_HOME:$LIBPATH
	cd $1
	gmake -f $1.mk install 2>&1 | tee $1.log
	cd ..
}

doclean()
{
	cds
	git clean -f -d
	git checkout .
	cp $MYHOME/archive/wlfullclient.jar ${BLD_ROOT}/LC/bld/TuxWS/cmdws/MTPConsole/libs/wlfullclient.jar
}


tux12() {
	if [ ! -z $TUXDIR_12 ]; then
		echo Set TUXDIR to $TUXDIR_12
		export TUXDIR=$TUXDIR_12
	else
		echo TUXDIR_12 is not set
	fi
}

tux22() {
	if [ ! -z $TUXDIR_22 ]; then
		echo Set TUXDIR to $TUXDIR_22
		export TUXDIR=$TUXDIR_22
	else
		echo TUXDIR_22 is not set
	fi
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

tuxEnv() {
	tux_path=$(stack_pop tux_path PATH)
	tux_ld=$(stack_pop tux_ld LD_LIBRARY_PATH)

	stack_push tux_path "$tux_path"
	stack_push tux_ld "$tux_ld"

	export PATH=$TUXDIR/bin:$PATH
	export LD_LIBRARY_PATH=$TUXDIR/lib:$LD_LIBRARY_PATH
}

cobolMFRestartLicense() {
	cd /opt/microfocus/licensing/autopass
	sudo ./autoPassdaemon.sh restart
	sudo /var/microfocuslicensing/bin/restartboth.sh
	cd -
}
