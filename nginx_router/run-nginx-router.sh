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
    if [ ! -f ./docker-compose.yml ]; then
        echo ""
        echo "Error: docker-compose.yml not found"
        echo "Run: make init"
        echo ""
        exit 0
    fi
    if ! docker network create my_shared_network
    then
        echo ""
        echo "Network my_shared_network already exists"
        echo ""
    fi
    docker compose up -d
    echo ""
    docker ps
    echo ""
    echo "Press ENTER to continue with the logs or Ctrl-C to cancel."
    read answer ;
    docker compose logs -f
    exit 0
elif [ "$ACTION" = "down" ]; then
    echo "Stopping nginx-router services..."
    docker compose down
    docker ps
    exit 0
elif [ "$ACTION" = "init" ]; then
    echo "Initializing nginx-router configuration..."
    if [ ! -f ./conf.d/nginx.exampleserver.conf ]; then
        echo ""
        echo "Copying nginx.exampleserver.conf to conf.d/"
        cp ./nginx.exampleserver.conf ./conf.d/.
    fi
    if [ ! -f ./docker-compose.yml ]; then
        echo ""
        echo "Copying docker-compose.example.yml to docker-compose.yml"
        cp ./docker-compose.example.yml ./docker-compose.yml
    fi
    exit 0
else
    echo "Error: Invalid action specified"
    exit 1
fi
