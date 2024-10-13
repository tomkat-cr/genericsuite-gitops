#!/bin/bash
# File: docker/install_docker_service.sh
# Install docker service on any Linux distro
# 2024-10-11 | CR

# Reference:
# https://docs.docker.com/engine/install/

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

get_other_users() {
    if [ $(whoami) != "root" ] ; then
        echo "This script must be run as root"
        exit 1
    fi
    if [ "$1" != "" ]; then
        export OTHER_USER=$1 ;
    fi
    if [ "$OTHER_USER" = "" ]; then
        export OTHER_USER=$SUDO_USER
    fi
    . "../scripts/get_os_name_type.sh" ;
    export OS_USER="$OS_NAME_LOWERCASED" ;
}

installation_rhel() {
    # Remove old versions of docker
    dnf remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine

    # Stop on any error
    set -e

    # Setup repository
    yum install -y yum-utils
    yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

    # Install docker
    yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

installation_centos() {
    # Remove old versions of docker
    yum remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine

    # Stop on any error
    set -e

    # Prepare repository
    yum install -y yum-utils
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # Install docker
    yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

installation_fedora() {
    # Remove old versions of docker
    dnf remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine

    # Stop on any error
    set -e

    # Prepare repository
    dnf -y install dnf-plugins-core
    dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    # Install docker
    dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

installation_ubuntu() {
    # Remove old versions of docker
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

    # Stop on any error
    set -e

    # Add Docker's official GPG key:
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    # Install docker
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

installation_debian() {
    # Remove old versions of docker
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

    # Stop on any error
    set -e

    # Add Docker's official GPG key:
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    # Install docker
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

installation_raspbian() {
    # Remove old versions of docker
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

    # Stop on any error
    set -e

    # Add Docker's official GPG key:
    apt-get update
    apt-get install ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    # Install docker
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Verify the Linux distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
else
    echo "This script only works on Linux distros"
    exit 1
fi

if [ "${OS}" = "ubuntu" ]; then
    ok=0
    if [ "${VER}" = "20.04" ]; then
        echo "Installing docker on Ubuntu ${VER}"
    elif [ "${VER}" = "22.04" ]; then
        echo "Installing docker on Ubuntu ${VER}"
    elif [ "${VER}" = "24.04" ]; then
        echo "Installing docker on Ubuntu ${VER}"
    else
        echo "Ubuntu version ${VER} is not supported"
        exit 1
    fi
    installation_ubuntu

elif [ "${OS}" = "debian" ]; then
    if [ "${VER}" = "11" ]; then
        echo "Installing docker on Debian ${VER}"
    elif [ "${VER}" = "12" ]; then
        echo "Installing docker on Debian ${VER}"
    else
        echo "Debian version ${VER} is not supported"
        exit 1
    fi
    installation_debian

elif [ "${OS}" = "centos" ]; then
    if [ "$(echo $VER | grep 7)" != "" ]; then
        echo "Installing docker on CentOS ${VER}"
    elif [ "$(echo $VER | grep 8)" != "" ]; then
        echo "Installing docker on CentOS ${VER}"
    else
        echo "CentOS version ${VER} is not supported"
        exit 1
    fi
    installation_centos

elif [ "${OS}" = "rhel" ]; then
    if [ "$(echo $VER | grep 7)" != "" ]; then
        echo "Installing docker on RHEL ${VER}"
    elif [ "$(echo $VER | grep 8)" != "" ]; then
        echo "Installing docker on RHEL ${VER}"
    elif [ "$(echo $VER | grep 9)" != "" ]; then
        echo "Installing docker on RHEL ${VER}"
    else
        echo "RHEL version ${VER} is not supported"
        exit 1
    fi
    installation_rhel

elif [ "${OS}" = "amzn" ]; then
    echo "Installing docker on Amazon Linux ${VER}"
    installation_rhel

elif [ "${OS}" = "fedora" ]; then
    if [ "$(echo $VER | grep 32)" != "" ]; then
        echo "Installing docker on Fedora ${VER}"
    elif [ "$(echo $VER | grep 33)" != "" ]; then
        echo "Installing docker on Fedora ${VER}"
    else
        echo "Fedora version ${VER} is not supported"
        exit 1
    fi
    installation_fedora

elif [ "${OS}" = "raspbian" ]; then
    if [ "${VER}" = "11" ]; then
        echo "Installing docker on Raspberri Pi ${VER}"
    elif [ "${VER}" = "12" ]; then
        echo "Installing docker on Raspberri Pi ${VER}"
    else
        echo "Raspberri Pi version ${VER} is not supported"
        exit 1
    fi
    installation_raspbian

else
    echo "Linux distro ${OS} ${VER} is not supported"
    exit 1
fi

# General variables

get_other_users $1 ;

echo ""
echo "Add user(s) $OTHER_USER $OS_USER to the docker group (to be able to start docker without root privileges)"
if [ "$OTHER_USER" != "" ] ; then
    usermod -a -G docker $OTHER_USER
fi
if [ "$OS_USER" != "" ] ; then
    usermod -a -G docker $OS_USER
fi

# Start docker engine (it's the same in both debian/ubuntu/rhel)
echo ""
echo "Starting docker engine..."
if ! docker ps > /dev/null 2>&1;
then
    systemctl start docker
fi
if ! docker ps > /dev/null 2>&1;
then
    echo ""
    echo "Docker is not running"
    exit 1
fi

echo ""
echo "Running docker hello-world..."
docker run hello-world

echo ""
echo "Docker service installed successfully"
