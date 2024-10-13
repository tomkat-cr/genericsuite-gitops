#!/bin/sh
# File: k8/get_defaults.sh
# 2022-02-26 | CR
#
CURRENT_DIR="`dirname "$0"`";
if [ -f "${CURRENT_DIR}/.env" ]; then
    set -o allexport; . "${CURRENT_DIR}/.env" ; set +o allexport ;
fi
if [ "${APP_FRONTEND_PUBLIC_URL}" == "" ]; then
    export APP_FRONTEND_PUBLIC_URL="http://dev.exampleapp.com";
fi
if [ "${APP_BACKEND_PUBLIC_URL}" == "" ]; then
    export APP_BACKEND_PUBLIC_URL="http://dev.exampleapp.com";
fi
if [ "${APP_FRONTEND_PORT}" == "" ]; then
    export APP_FRONTEND_PORT="3001";
fi
if [ "${APP_BACKEND_PORT}" == "" ]; then
    export APP_BACKEND_PORT="5000";
fi
