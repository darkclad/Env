#/usr/bin/bash

echo -------------- Setting up the environment --------------

. /home/dvladi/env/$HOSTNAME.site.sh

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------
export BLD_ROOT=$U01/$BLD_DIR
export CRONDIR=$BLD_ROOT/cron
export TUXDIR=$BLD_ROOT/$SITE/bld

export PATH=$PATH:.:$HOME/.local/bin:$HOME/bin

export HISTSIZE=30000
export HISTFILESIZE=30000

PS1='\u@\h:$PWD> '

# -----------------------------------------------------------
# Aliases
# -----------------------------------------------------------

alias gs='git status'
alias gco='git checkout'
alias gb='git branch'
alias gup='git fetch && git pull'
alias gclean='git reset --hard && git clean -fd'
alias gcp='git cherry-pick'
alias ga='git add -A'

alias work='cd $HOME/work'

alias cdh='cd ~'
alias cdb='cd $BLD_ROOT/cron/build'
alias cdl='cd $BLD_ROOT/cron/log'
alias cds='cd $BLD_ROOT/LC/bld'
alias cdt='cd $BLD_ROOT/LC/bld/TuxWS'
alias cdg='cd $BLD_ROOT/LC/bld/TuxWS/gwws'
alias cdu='cd ~/SNA122264/tma_sna'
alias cdqa='cd $BLD_ROOT/LC/bld/qa/sanity_tests/apps'

alias hosts='cat ~/.ssh/config | grep -w Host'
alias hostsn='cat ~/.ssh/config | grep -w Hostname'

alias fedit='nano ~/env/environment.sh'
alias fedith='nano ~/env/$HOSTNAME.sh'
alias fload='. ~/env/environment.sh'
alias floadh='. ~/env/$HOSTNAME.sh'
alias sedit='nano ~/.ssh/config'

alias ports='sudo netstat -tulpn | grep LISTEN'

alias cdo='cd $ORACLE_HOME'
alias cdw='cd $HOME/work'
alias cdd='cd $HOME/Downloads'
alias cdsa='cd $SANITY_DIR'
alias cdj='cd ~/Jenkins'

alias dsol='ssh slc11kmn'
alias sedit='nano ~/.ssh/config'
alias drem1='ssh rem1'
alias drem2='ssh rem2'
alias drem3='ssh rem3'
alias saix='ssh beadev@slc18fic'
alias daix='ssh slc18fic'
alias dcrm='ssh crm1'


# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

pause() {
	read -s -n 1 -p "Press any key to continue . . ."
	#read TheSomething?'Press any key to continue . . .'
	echo ""
}

set_env() {
	if [ "$1" != "" ]; then
		export U01="$1"
	fi
	$HOME/env/environment.sh
}

function sshPwdLess()
{
	remote="$1"
	keygen=${2:-"n"}
	port=${3:-"22"}
	file=${4:-"id_rsa.pub"}
	if [ -z $remote ]; then
		echo "Use sshPwdLess RemoteHost [Generate key] [Port]"
		return
	fi

	if [ "$2" != "n" ]; then
		ssh-keygen -t rsa
	fi

	echo "Creating .ssh folder on remote host $remote"
	ssh $remote -p $port mkdir -p .ssh
	echo "Copying ~/.ssh/id_rsa.pub to remote host $remote"
	cat ~/.ssh/id_rsa.pub | ssh $remote -p $port 'cat >> ~/.ssh/authorized_keys'
	echo "Setting permissions on remote host $remote"
	ssh $remote -p $port 'chmod 700 ~/.ssh; chmod 640 ~/.ssh/authorized_keys'
}

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
  git diff --summary | grep --color 'mode change 100644 => 100755' | cut -d' ' -f7- | xargs -d'\n' chmod -x
  git clean -f
  git clean -fd
  git clean -fx
  git clean -fX
  git checkout OTMQ/
  git checkout gp/
  git checkout TuxJS/
  git checkout snmp/
  git checkout tuxedo/
  git checkout tuxedo_EM/
  git checkout giconv/
  git checkout objtm/
  git checkout orb/
  git checkout samples/
  git checkout jca/
  rm -rf bin/ lib/
  cp ~/archive/wlfullclient.jar ${BLD_ROOT}/LC/bld/TuxWS/cmdws/MTPConsole/libs/wlfullclient.jar
}

if [ -f ~/env/`hostname`.sh ]; then
  echo -------------- Setting up the `hostname` environment --------------
  . ~/env/`hostname`.sh
fi
