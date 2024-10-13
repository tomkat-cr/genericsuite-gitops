#!/bin/bash
# File: k8/k8_install_kubernetes.sh
# Install kubernetes service on any Linux distro
# 2024-10-13 | CR

# Reference:
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

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

installation_x86_64() {
    echo ""
    echo "Download the latest release file"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    echo ""
    echo "Download the kubectl checksum file"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
}

installation_arm64() {
    echo ""
    echo "Download the latest release file"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    echo ""
    echo "Download the kubectl checksum file"
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
}

# General variables
get_os_data $1 ;

echo ""
echo "Installing kubectl binary with curl on Linux..."

# Verify the Linux distro
if [ "$(uname -m)" = "x86_64" ]; then
    echo "Installing kubernetes on x86_64"
    installation_x86_64
elif [ "$(uname -m)" = "aarch64" ]; then
    echo "Installing kubernetes on aarch64"
    installation_arm64
elif [ "$(uname -m)" = "arm64" ]; then
    echo "Installing kubernetes on arm64"
    installation_arm64
else
    echo "This script only works on x86_64 or arm64 distros"
    exit 1
fi

echo ""
echo "Validate the kubectl binary against the checksum file:"
if [ `echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check` != "kubectl: OK" ]
then
    echo "Error: The kubectl binary did not pass the checksum validation test"
    exit 1
fi

echo ""
echo "Installing kubectl binary..."
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Test to ensure the version is up-to-date:"
if ! kubectl version --client
then
    echo "Error: 'kubectl version --client' failed"
    exit 1
fi

echo ""
echo "Kubernetes installed successfully"
