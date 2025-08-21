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
    echo "Restarting services..."
    docker-compose restart
    exit 0
elif [ "$ACTION" = "run" ]; then
    echo "Starting services..."
    docker-compose up -d
    exit 0
elif [ "$ACTION" = "down" ]; then
    echo "Stopping services..."
    docker-compose down
    exit 0
else
    echo "Error: Invalid action specified"
    exit 1
fi
