#!/bin/bash
# File: ollama/run_stable_diffusion.sh
# Stable Diffusion Webui run
# 2024-10-13 | CR

# Reference:
# https://ntck.co/ep_401

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
    SUDO_CMD="sudo"
fi

cd "$HOME/stable-diffusion"
$SUDO_CMD ./webui.sh --listen --api
