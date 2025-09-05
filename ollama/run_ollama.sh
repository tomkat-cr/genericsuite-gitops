#!/bin/bash
# File: ollama/run_ollama.sh
# Run Ollama service
# 2054-08-08 | CR

set -euo pipefail
IFS=$'\n\t'

run_done() {
    echo ""
    echo "Done!"
    exit 0
}

run_ollama() {
    # Stop and remove any previous container
    run_stop
    echo ""
    echo "Starting Ollama..."
    ollama
    if [ $? -ne 0 ]; then
        echo ""
        echo "Failed to start ollama"
        echo ""
        exit 1
    fi
}

run_install() {
    sh ./install_ollama_service.sh
}

run_update() {
    # https://github.com/ollama/ollama/blob/main/docs/linux.md
    echo ""
    echo "Updating ollama..."
    echo ""
    curl -fsSL https://ollama.com/install.sh | sh
    if [ $? -ne 0 ]; then
        echo ""
        echo "Failed to update ollama"
        echo ""
        exit 1
    fi
}

run_stop() {
    echo ""
    echo "Stopping Ollama..."
    echo ""
    # A better way to check if a command exists is using command -v.
    if command -v systemctl &> /dev/null
    then
        echo ""
        echo "Stopping Ollama with systemctl..."
        if ! ${SUDO_CMD} systemctl stop ollama.service
        then
            echo ""
            echo "Failed to stop Ollama with systemctl"
            echo ""
            exit 1
        fi
        echo ""
        echo "Checking if Ollama is still running..."
        if systemctl is-active --quiet ollama.service;
        then
            echo ""
            echo "Failed to stop Ollama, it's still running"
            echo ""
            exit 1
        fi
    else
        echo "Stopping Ollama with kilall"
        if ! ${SUDO_CMD} killall -s 9 ollama
        then
            echo ""
            echo "Failed to stop Ollama"
            echo ""
            exit 1
        fi
        echo "Checking if Ollama is still running..."
        if ollama --version &> /dev/null
        then
            echo ""
            echo "Failed to stop Ollama, it's still running"
            echo ""
            exit 1
        fi
    fi
}

run_open() {
    echo ""
    echo "Opening public access to port ${OLLAMA_PORT} in the firewall"
    echo ""
    sh ../scripts/firewall_manager.sh open ${OLLAMA_PORT}
}

run_close() {
    echo ""
    echo "Closing public access to port ${OLLAMA_PORT} in the firewall"
    echo ""
    sh ../scripts/firewall_manager.sh close ${OLLAMA_PORT}
}

run_help() {
    echo ""
    echo "Usage: $0 run|stop|install|update|open|close"
    echo ""
    exit 0
}

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
    SUDO_CMD="sudo"
fi

export RUN_WITH_GPU="${RUN_WITH_GPU:-1}";
export OLLAMA_PORT="${OLLAMA_PORT:-11434}"

ACTION="${ACTION:-$1}"
if [ "$ACTION" = "" ]; then
    ACTION="run"
fi

. "../scripts/get_os_name_type.sh" ;

echo ""
echo "******************"
echo "* OLLAMA MANAGER *"
echo "******************"
echo ""
echo "Action: $ACTION"

if [ "$ACTION" = "run" ]; then
    run_ollama
    run_done
fi

if [ "$ACTION" = "stop" ]; then
    run_stop
    run_done
fi

if [ "$ACTION" = "install" ]; then
    run_install
    run_done
fi

if [ "$ACTION" = "update" ]; then
    run_update
    run_done
fi

if [ "$ACTION" = "open" ]; then
    run_open
    run_done
fi

if [ "$ACTION" = "close" ]; then
    run_close
    run_done
fi

echo ""
echo "Invalid option: '$ACTION'"
echo ""
run_help
