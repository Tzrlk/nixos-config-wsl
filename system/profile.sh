#!/usr/bin/env bash
# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

if [ "${PS1-}" ]; then
	# The file bash.bashrc already sets the default PS1.
	if [ "${BASH-}" ] && [ "$BASH" != "/bin/sh" ]; then
		if [ -f /etc/bash.bashrc ]; then
			# shellcheck source=./bashrc.sh
			. /etc/bash.bashrc
		fi
	else
		# shellcheck source=./bash.bashrc.d/04-prompt.sh
		. /etc/bash.bashrc.d/04-prompt.sh
	fi
fi

# Load profile extensions.
if [ -d /etc/profile.d ]; then
	for i in /etc/profile.d/*.sh; do
		if [ -r "${i}" ]; then
			# shellcheck source=/etc/profile.d/*.sh
			. "${i}"
		fi
	done
	unset i
fi
