#!/usr/bin/bash

_load_env() {
	if [ -f $1 ]; then
		echo "-------------- Setting $2 environment --------------"
		. $1
	else
		echo "$1 does not exits. Creating"
		touch $1
	fi
}

echo "-------------- Setting up the environment --------------"

_mydir=$(realpath $(dirname ${BASH_SOURCE[0]}))
_os_file=$_mydir/OS/$OSTYPE.sh
_host_site_file=$_mydir/hosts/`hostname`.site.sh
_host_file=$_mydir/hosts/`hostname`.sh
_env_file=$_mydir/environment.sh

# Site environment file MUST set site global variables: U01
_load_env $_host_site_file "Site"


_env_d_group_file=$_mydir/GROUP/$D_NAME_GROUP.sh

# -----------------------------------------------------------
# Variables
# -----------------------------------------------------------

export MYHOME=${MYHOME:-$HOME}

if [ -z $_env_is_set ]; then
	export PATH=$PATH:.:$HOME/.local/bin:$HOME/bin
	export _env_is_set=1
fi

export HISTSIZE=30000
export HISTFILESIZE=30000000
export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

if [ -z $bash_level ]; then
	bash_level=0
	PS1='\u@\h:$PWD> '
else
	bash_level=$((bash_level+1))
	PS1='\u@\h-$bash_level:$PWD> '
fi
export bash_level

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

alias work='cd $MYHOME/work'

alias cdh='cd $MYHOME'
alias cde='cd $MYHOME/env'

alias dus='du -h --max-depth=1 . 2>/dev/null | sort -h'

alias hosts='cat $MYHOME/.ssh/config | grep -w Host'
alias hostsn='cat $MYHOME/.ssh/config | grep -w Hostname'

alias fedit='nano $_env_file'
alias fedito='nano $_os_file'
alias fedith='nano $_host_file'
alias feditg='nano $_env_d_group_file'
alias fediths='nano $_host_site_file'

alias fload='. $_env_file'
alias floadh='. $_host_file'

alias sedit='nano $MYHOME/.ssh/config'
alias pedit='nano $MYHOME/.bash_profile'
alias redit='nano $MYHOME/.bashrc'

alias ports='sudo netstat -tulpn | grep LISTEN'

alias cdw='cd $U01'
alias cdd='cd $HOME/Downloads'

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

checkSym()
{
	_out=`objdump -t $2 2>/dev/null | grep $1 | grep -v UND`
	if [ $? == 0 ]; then
		echo $filename
		echo $_out
	fi
}

findSym()
{
	for filename in *.a; do
		checkSym "$1" "$filename"
	done

	for filename in *.so; do
		checkSym "$1" "$filename"
	done
}

dosync() {
	if [ $# -lt 2 ]; then
		echo "Usage: dosync local_dir host:remote_dir"
	else
		_host=$1
		shift
		echo
		for _dir in "$@"; do
			echo ------------ Syncing $_dir to $_host
			echo "Running: rsync $rsync_opts -e ssh $_dir $_host:/`basename $_dir`"
			rsync $rsync_opts -e ssh $_dir $_host:/`basename $_dir`
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
			echo "Running: rsync $rsync_opts -e ssh $_host:$REMOTE_SYNC_DIR/$_dir $U01/`dirname $_dir`"
			rsync $rsync_opts -e ssh $_host:$REMOTE_SYNC_DIR/$_dir $U01/`dirname $_dir`
		done
	fi
}

pause() {
	read -s -n 1 -p "Press any key to continue . . ."
	#read TheSomething?'Press any key to continue . . .'
	echo ""
}

set_env() {
	if [ "$1" != "" ]; then
		export U01="$1"
	fi
	. $_env_file
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
	echo "Copying $MYHOME/.ssh/id_rsa.pub to remote host $remote"
	cat $MYHOME/.ssh/id_rsa.pub | ssh $remote -p $port 'cat >> $MYHOME/.ssh/authorized_keys'
	echo "Setting permissions on remote host $remote"
	ssh $remote -p $port 'chmod 700 $MYHOME/.ssh; chmod 640 $MYHOME/.ssh/authorized_keys'
}

checkDebug() {
	for filename in `ls $1`; do
		[ -e "$filename" ] || continue
		echo "File: $filename"
		readelf -S $filename | grep debug
	done
}


if [ -f $_mydir/stack.sh ]; then
	echo "-------------- Stack functions are enabled --------------"
	. $_mydir/stack.sh
	stack_clear_all
fi

_load_env $_os_file "$OS"
_load_env $_env_d_group_file "$D_NAME_GROUP"
_load_env $_host_file "`hostname`"
