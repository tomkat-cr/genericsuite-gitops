#!/bin/bash
# File: ollama/install_ollama_service.sh
# Install ollama service on any Linux distro
# 2024-10-13 | CR

# Reference:
# https://ollama.com/download/linux

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
	SUDO_CMD="sudo"
fi

get_os_data() {
    if [ $(whoami) != "root" ] ; then
        echo "This script must be run as root"
        exit 1
    fi
    if ! . "../scripts/get_os_name_type.sh"
    then
        echo ""
        echo "Error: Could not get the OS name and type"
        exit 1
    fi
}

# General variables
get_os_data $1 ;
OLLAMA_PORT="11434"

echo ""
echo "Installing ollama on Linux..."
curl -fsSL https://ollama.com/install.sh | sh

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

# Verify the Linux distro
if [ "$OS_TYPE" = "debian" ]; then
    $SUDO_CMD ufw allow ${OLLAMA_PORT}/tcp
    # Reload firewall
    $SUDO_CMD ufw reload
elif [ "$OS_TYPE" = "rhel" ]; then
    $SUDO_CMD firewall-cmd --zone=public --add-port=${OLLAMA_PORT}/tcp --permanent
    # Reload firewall
    $SUDO_CMD firewall-cmd --reload
else
    echo "Linux distro [$OS_TYPE] is not supported"
    exit 1
fi

echo ""
echo "Ollama service installed successfully"
