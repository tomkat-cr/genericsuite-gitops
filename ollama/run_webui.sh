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

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
	SUDO_CMD="sudo"
fi

if [ "$RUN_WITH_GPU" = "" ]; then
    export RUN_WITH_GPU="1";
fi

if [ "$WEBUI_PORT" = "" ]; then
    export WEBUI_PORT="3000"
fi

if [ "$ACTION" = "" ]; then
    ACTION="$1"
fi
if [ "$ACTION" = "" ]; then
    ACTION="run"
fi

. "../scripts/get_os_name_type.sh" ;

echo ""
echo "**********************"
echo "* OPEN WEBUI MANAGER *"
echo "**********************"
echo ""
echo "Action: $ACTION"

if [ "$ACTION" = "install" ]; then
    echo ""
    echo "NVIDIA container-toolkit install"

    if [ "$OS_TYPE" = "debian" ]; then
        echo ""
        echo "Installing with Apt..."

        echo ""
        echo "Configure the production repository"

        curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | $SUDO_CMD gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
        && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            $SUDO_CMD tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

        echo ""
        echo "Optionally, configure the repository to use experimental packages"

        sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

        echo ""
        echo "Update the packages list from the repository"

        $SUDO_CMD apt-get update

        echo ""
        echo "Install the NVIDIA Container Toolkit packages"

        $SUDO_CMD apt-get install -y nvidia-container-toolkit
    elif [ "$OS_TYPE" = "rhel" ]; then
        echo ""
        echo "Installing with Yum or Dnf..."

        echo ""
        echo "Configure the production repository"

        curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
        $SUDO_CMD tee /etc/yum.repos.d/nvidia-container-toolkit.repo

        echo ""
        echo "Optionally, configure the repository to use experimental packages"

        $SUDO_CMD yum-config-manager --enable nvidia-container-toolkit-experimental

        echo ""
        echo "Install the NVIDIA Container Toolkit packages"

        $SUDO_CMD yum install -y nvidia-container-toolkit
    else
        echo "Linux distro [$OS_TYPE] is not supported"
        exit 1
    fi

    echo ""
    echo "Configuration..."

    echo ""
    echo "Configure the container runtime by using the nvidia-ctk command"

    $SUDO_CMD nvidia-ctk runtime configure --runtime=docker
        # The nvidia-ctk command modifies the /etc/docker/daemon.json file on the host.
        # The file is updated so that Docker can use the NVIDIA Container Runtime.

    echo ""
    echo "Restart the Docker daemon"

    $SUDO_CMD systemctl restart docker

    echo ""
    echo "Done! NVIDIA container-toolkit install was completed."
fi

if [ "$ACTION" = "open" ]; then
    echo ""
    echo "Opening public access to port ${WEBUI_PORT} in the firewall"
    sh ../scripts/firewall_manager.sh open ${WEBUI_PORT}
fi

if [ "$ACTION" = "close" ]; then
    echo ""
    echo "Closing public access to port ${WEBUI_PORT} in the firewall"
    sh ../scripts/firewall_manager.sh close ${WEBUI_PORT}
fi

if [ "$ACTION" = "stop" ]; then
    # Stop and remove any previous container
    docker stop open-webui && docker rm open-webui
    docker ps
fi

if [ "$ACTION" = "run" ]; then
    # Stop and remove any previous container
    docker stop open-webui && docker rm open-webui
    if [ "$RUN_WITH_GPU" = "0" ]; then
        # With NO GPU
        # docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main
        docker run -d -p $WEBUI_PORT:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
    else
        # With GPU
        docker run -d -p $WEBUI_PORT:8080 --gpus all --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
    fi
    docker ps
    sleep 50
    docker ps
fi
