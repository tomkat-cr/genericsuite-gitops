#!/bin/bash
# run-nginx-router.sh
# 2025-08-21 | CR
#
REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

if [ -f ./.env ]; then
    set -o allexport; . ./.env; set +o allexport ;
fi

ACTION=$1
if [ -z "$ACTION" ]; then
    echo "Error: No action specified"
    exit 1
fi
if [ "$ACTION" = "restart" ]; then
    echo "Restarting nginx-router services..."
    docker compose restart
    docker ps
    exit 0
elif [ "$ACTION" = "run" ]; then
    echo "Starting nginx-router services..."
    if ! docker network create my_shared_network
    then
        echo ""
        echo "Network my_shared_network already exists"
        echo ""
    fi
    docker compose up -d
    docker ps
    exit 0
elif [ "$ACTION" = "down" ]; then
    echo "Stopping nginx-router services..."
    docker compose down
    docker ps
    exit 0
else
    echo "Error: Invalid action specified"
    exit 1
fi
