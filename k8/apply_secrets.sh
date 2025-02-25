#!/bin/sh
# File: k8/apply_secrets.sh
# 2022-02-25 | CR
#
# Ref:
# https://kubernetes.io/docs/tasks/inject-data-application/_print/
#
CURRENT_DIR="`dirname "$0"`"
GENERATE_SECRETS=1
if [ ! -f "${CURRENT_DIR}/.env" ]; then
    echo "Error [1.1]: Please define the .env file with the secrets, file: '${CURRENT_DIR}/.env'";
    GENERATE_SECRETS=0;
else
    if ! . ${CURRENT_DIR}/get_defaults.sh
    then
        if ! source ${CURRENT_DIR}/.env
        then
            echo "Error [1.2]: Unable to get the variables from .env and get_defaults.sh";
            GENERATE_SECRETS=0;
        fi
    fi
    if [ "${APP_DB_URI}" == "" ]; then
        echo "Error [2]: Missing APP_DB_URI variable...";
        GENERATE_SECRETS=0;
    fi
    if [ "${APP_SECRET_KEY}" == "" ]; then
        echo "Error [3]: Missing APP_SECRET_KEY variable...";
        GENERATE_SECRETS=0;
    fi
    if [ "${SECRET_GROUP}" == "" ]; then
        echo "Error [4]: Missing SECRET_GROUP variable...";
        GENERATE_SECRETS=0;
    fi
    if [ "${APP_BACKEND_PUBLIC_URL}" == "" ]; then
        echo "Error [5]: Missing APP_BACKEND_PUBLIC_URL variable...";
        GENERATE_SECRETS=0;
    fi
    if [ "${APP_BACKEND_PORT}" == "" ]; then
        echo "Error [6]: Missing APP_BACKEND_PORT variable...";
        GENERATE_SECRETS=0;
    fi
fi
if [ ${GENERATE_SECRETS} -eq 1 ]; then
    kubectl delete secret generic ${SECRET_GROUP}
    kubectl create secret generic ${SECRET_GROUP} \
        --from-literal="exampleapp_backend_public_url=${APP_BACKEND_PUBLIC_URL}:${APP_BACKEND_PORT}" \
        --from-literal="exampleapp_db_uri=${APP_DB_URI}" \
        --from-literal="exampleapp_secret_key=${APP_SECRET_KEY}"
    if [ $? -eq 0 ]; then
      echo "Secrets were created for '${SECRET_GROUP}' -> $?";
    else
      echo "Error [5]: Could not create the secrets for '${SECRET_GROUP}'";
    fi
else
    echo "Error [4]: Could not create the secrets for '${SECRET_GROUP}'";
fi
