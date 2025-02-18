#!/bin/bash
# File: scripts/firewall_manager.sh
# Run Open/close public access to firewall ports
# 2024-10-14 | CR

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
	SUDO_CMD="sudo"
fi

firewall_manager() {
    local action="$1"
    local port="$2"
    local ufw_action=""

    if [ "$OS_TYPE" = "" ]; then
    	if ! . ../scripts/get_os_name_type.sh
        then
            if ! source ../scripts/get_os_name_type.sh
            then
                echo ""
                echo "Error: Could not get the OS name and type"
                exit 1
            fi
        fi
    fi

    if [ "$OS_TYPE" = "debian" ]; then
        if [ "${action}" = "open" ]; then
            ufw_action="allow"
        elif [ "${action}" = "close" ]; then
            ufw_action="deny"
        else
            echo ""
            echo "Invalid action. Must be: open|close"
            exit 1
        fi
        echo ""
        echo "Opening public access to port ($OS_TYPE)..."
        echo "$SUDO_CMD ufw ${ufw_action} ${port}/tcp"
        $SUDO_CMD ufw ${ufw_action} ${port}/tcp
        echo ""
        echo "$SUDO_CMD ufw reload"
        $SUDO_CMD ufw reload
        echo ""
        echo "$SUDO_CMD ufw status"
        $SUDO_CMD ufw status

    elif [ "$OS_TYPE" = "rhel" ]; then
        if [ "${action}" = "open" ]; then
            ufw_action="--add-port"
        elif [ "${action}" = "close" ]; then
            ufw_action="--remove-port"
        else
            echo ""
            echo "Invalid action. Must be: open|close"
            exit 1
        fi
        echo ""
        echo "Closing public access to port ($OS_TYPE)..."
        echo ""
        echo "$SUDO_CMD firewall-cmd --zone=public ${ufw_action}=${port}/tcp --permanent"
        $SUDO_CMD firewall-cmd --zone=public ${ufw_action}=${port}/tcp --permanent
        echo ""
        echo "$SUDO_CMD firewall-cmd --reload"
        $SUDO_CMD firewall-cmd --reload
        echo ""
        echo "$SUDO_CMD firewall-cmd --list-all"
        $SUDO_CMD firewall-cmd --list-all

    else
        echo "Linux distro [$OS_TYPE] is not supported"
        exit 1
    fi
}

ACTION="$1"
PORT="$2"

echo ""
echo "********************"
echo "* FIREWALL MANAGER *"
echo "********************"
echo ""
echo "Open/close public access to firewall ports"
echo ""
echo "Action: $ACTION"
echo "Port: $PORT"

if [ "$ACTION" = "" ]; then
    echo ""
    echo "Action not specified"
    echo "Usage: $0 [open|close] [port]"
    exit 1
fi

if [ "$PORT" = "" ]; then
    echo ""
    echo "Port not specified"
    echo "Usage: $0 [open|close] [port]"
    exit 1
fi

firewall_manager $ACTION $PORT
