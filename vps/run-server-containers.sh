#!/bin/bash
# File: "vps/run-server-containers.sh"
# 2022-03-07 | CR
#
CURRENT_DIR="`dirname "$0"`"
cd "${CURRENT_DIR}" ;

export APP_VERSION="`cat "version.txt"`"

if ! docker info > /dev/null 2>&1; then
    echo "This script uses docker, and it isn't running - Try to start it..."
    service docker start
fi

if [ -f "${CURRENT_DIR}/.env" ]; then
    set -o allexport; . "${CURRENT_DIR}/.env" ; set +o allexport ;
fi

export cmd_par="$1";
if [ "$1" == "" ] ;
then
    export cmd_par="up -d";
fi
docker-compose -f ./docker-compose.yml ${cmd_par} ;
docker ps ;
