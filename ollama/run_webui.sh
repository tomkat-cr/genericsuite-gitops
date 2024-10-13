#!/bin/bash
# File: ollama/run_webui.sh
# Run Open WebUi Docker Container
# 2024-10-13 | CR

# Reference:
# https://github.com/open-webui/open-webui?tab=readme-ov-file#installation-with-default-configuration
# https://ntck.co/ep_401

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

if [ "$RUN_WITH_GPU" = "" ]; then
    export RUN_WITH_GPU="1";
fi

if [ "$WEBUI_PORT" = "" ]; then
    export WEBUI_PORT="3000"
fi

if [ "$OPEN_PORT" = "1" ]; then
    . "../scripts/get_os_name_type.sh" ;

    if [ "$OS_TYPE" = "debian" ]; then
        sudo ufw allow ${WEBUI_PORT}/tcp
        sudo ufw reload
    elif [ "$OS_TYPE" = "rhel" ]; then
        sudo firewall-cmd --zone=public --add-port=${WEBUI_PORT}/tcp --permanent
        sudo firewall-cmd --reload
    else
        echo "Linux distro [$OS_TYPE] is not supported"
        exit 1
    fi
fi

# Stop and remove any previous container
docker stop open-webui
docker rm open-webui

if [ "$RUN_WITH_GPU" = "0" ]; then
    # With NO GPU
    # docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main
    docker run -d -p $WEBUI_PORT:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
else
    # With GPU
    docker run -d -p $WEBUI_PORT:8080 --gpus all --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
fi
