#!/usr/bin/env bash

# Start our bash prompt with a vertical tab to make separating commands easier.
# Also, we're just going to assume a coloured prompt in all cases.
PS1='\v'

# Set variable identifying the chroot you work in, then append conditional
# inclusion of it into the prompt.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
	PS1+='${debian_chroot:+($debian_chroot)}'
fi

# Add the current user only if we're in a different session (e.g. su).
prompt_user='\[\033[01;32m\]\u\[\033[00m\]:'
PS1+="\${XDG_SESSION_ID:+${prompt_user}}"
unset prompt_user

# Add the full working directory
PS1+='\[\033[01;34m\]\w\[\033[00m\]'

# Finally add the prompt character and a space on the next line, so long
# working directories don't push the prompt off the side of the screen.
PS1+='\n\$ '
