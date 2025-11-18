#!/bin/bash
# File: "vps/run-server-containers.sh"
# 2022-03-07 | CR
#
set -euo pipefail
IFS=$'\n\t'

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${CURRENT_DIR}" ;

if [ -f "version.txt" ]; then
  export APP_VERSION="$(cat "version.txt")"
else
  echo "Error: version.txt not found"
  exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo "This script uses docker, and it isn't running - trying to start it..."
    if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl start docker || true
    else
        sudo service docker start || true
    fi
fi

if [ -f "${CURRENT_DIR}/.env" ]; then
    set -o allexport; . "${CURRENT_DIR}/.env" ; set +o allexport ;
fi

cmd_par=${1:-"up -d"}

# Prefer modern docker compose if available
if docker compose version >/dev/null 2>&1; then
  docker compose -f ./docker-compose.yml ${cmd_par}
else
  docker-compose -f ./docker-compose.yml ${cmd_par}
fi

docker ps ;
