#!/usr/bin/env bash

# Ensure GUI environment variables are set properly.
WSLG_HOME=/mnt/wslg
export PULSE_SERVER=unix:${WSLG_HOME}/PulseServer
export DISPLAY=:0

# Poorly understood debugging magic.
export LIBGL_ALWAYS_INDIRECT=1
