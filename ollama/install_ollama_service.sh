#!/bin/bash
# File: ollama/install_ollama_service.sh
# Install ollama service on any Linux distro
# 2024-10-13 | CR

# Reference:
# https://ollama.com/download/linux

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

# General variables
OLLAMA_PORT="11434"

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
	SUDO_CMD="sudo"
fi

echo ""
echo "Installing ollama on Linux..."
$SUDO_CMD curl -fsSL https://ollama.com/install.sh | sh

echo ""
echo "Checking ollama installation..."
if ! ollama --version
then
    echo "Error: ollama installation failed"
    exit 1
fi
if ! ollama list
then
    echo "Error: ollama service has issues"
    exit 1
fi

# Stop on any error
set -e

echo ""
echo "Open the firewall to allow the ollama port [$OLLAMA_PORT]:"

sh ../scripts/firewall_manager.sh open ${OLLAMA_PORT}

echo ""
echo "Ollama service installed successfully"
