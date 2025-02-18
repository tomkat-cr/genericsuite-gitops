#!/bin/bash
# File: ollama/open_ollama_port_to_lan.sh
# Make the ollama port listen to the LAN
# 2024-10-13 | CR

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

# Ollama port
OLLAMA_PORT="11434"

# Path to the service file
SERVICE_FILE="/etc/systemd/system/ollama.service"

# Automate this operation:
# nano /etc/systemd/system/ollama.service
# [Service]
# ExecStart=/usr/local/bin/ollama serve
#    .
#    .
# Add this line in the [Service] section:
# Environment="OLLAMA_HOST=0.0.0.0:11434"

echo ""
echo "Configuring ollama to listen on all interfaces..."

# Check if the file exists
if [ ! -f "$SERVICE_FILE" ]; then
    echo "Error: $SERVICE_FILE does not exist. Is ollama installed correctly?"
    exit 1
fi

# Add the Environment line if it doesn't exist
if ! grep -q "OLLAMA_HOST=0.0.0.0:$OLLAMA_PORT" "$SERVICE_FILE"; then
    echo ""
    echo "Adding the line 'Environment=\"OLLAMA_HOST=0.0.0.0:\$OLLAMA_PORT\"'..."
    $SUDO_CMD sed -i '/^\[Service\]/a Environment="OLLAMA_HOST=0.0.0.0:\$OLLAMA_PORT"' "$SERVICE_FILE"
    echo ""
    echo "Replacing the port number..." 
    $SUDO_CMD sed -i "s/\$OLLAMA_PORT/$OLLAMA_PORT/g" "$SERVICE_FILE"
    echo ""
    echo "Added OLLAMA_HOST environment variable to $SERVICE_FILE"
    echo ""
    cat "$SERVICE_FILE"
    echo ""
else
    echo "OLLAMA_HOST environment variable already set in $SERVICE_FILE"
fi

# Reload systemd to apply changes
$SUDO_CMD systemctl daemon-reload

# Restart ollama service
if ! $SUDO_CMD systemctl restart ollama
then
    echo "Error running: $SUDO_CMD systemctl restart ollama"
    exit 1
fi

echo "Ollama service configured to listen on all interfaces"
