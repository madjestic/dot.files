# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
export PATH=$PATH:~/.cabal/bin:~/bin:~/.local/bin:/usr/local/lib
export PATH=$PATH:~/.local/share/fonts
export GIT_EDITOR=emacs

export PROJECTS=~/Projects
export EDITOR=/usr/bin/emacs
export VISUAL=/usr/bin/emacs
export HISTSIZE=9999

alias xterm="xterm -fa \"DejaVu\ Sans\ Mono:pixelsize=15\""
alias ec="emacsclient -c"

[ -f "/home/madjestic/.ghcup/env" ] && source "/home/madjestic/.ghcup/env" # ghcup-env

#export LANG="ru_RU.iso88595"
#export LANG="ru_RU.utf8"
#export LC_COLLATE="C.UTF-8"

export LIBVA_DRIVER_NAME="iHD"

# refresh icon cache
# fc-cache -fv
