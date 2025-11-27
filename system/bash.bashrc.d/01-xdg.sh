#!/usr/bin/env bash
# These are being explicitly set in the environment because apparently some
# applications don't actually implement the defaults themselves.

# All of these exports have the default values as-per the XDG spec.
export \
	XDG_DATA_HOME="${HOME}/.local/share" \
	XDG_DATA_DIRS='/usr/local/share/:/usr/share/' \
	XDG_CONFIG_HOME="${HOME}/.config" \
	XDG_CONFIG_DIRS='/etc/xdg' \
	XDG_STATE_HOME="${HOME}/.local/state" \
	XDG_CACHE_HOME="${HOME}/.cache" \
	XDG_RUNTIME_DIR="/run/user/${UID}"

# Any of these exports aren't in the spec, but probably should be.
export \
	XDG_BIN_HOME="${HOME}/.local/bin"

# Ensure the local bin folder is added to the path.
export PATH="${XDG_BIN_HOME}:${PATH}"

