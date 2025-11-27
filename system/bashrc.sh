# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Load bash profile extensions.
if [ -d /etc/bash.bashrc.d ]; then
	for i in /etc/bash.bashrc.d/*.sh; do
		if [ -r "${i}" ]; then
			# shellcheck source=/etc/bash.bashrc.d/*.sh
			. "${i}"
		fi
	done
	unset i
fi
