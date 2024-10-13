#!/bin/sh
# k8/k8_install_minikube.sh
# 2024-10-13 | CR

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

docker_dependencies() {
  if ! docker ps > /dev/null 2>&1;
  then
      sh ../docker/install_docker_service.sh
  fi

  if ! docker ps > /dev/null 2>&1;
  then
      echo ""
      echo "Docker is not running"
      exit 1
  fi
}

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

# General variables
get_other_users $1 ;

# Check if docker is installed
docker_dependencies

if [ "$OS_TYPE" = "debian" ]; then
    sh k8_install_minikube_ubuntu.sh $OTHER_USER $OS_USER
elif [ "$OS_TYPE" = "rhel" ]; then
    sh k8_install_minikube_centos.sh $OTHER_USER $OS_USER
else
    echo "Linux distro [$OS_TYPE] is not supported"
    exit 1
fi
