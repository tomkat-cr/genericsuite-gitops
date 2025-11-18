#!/bin/bash
# File: "vps/deploy_to_vps.sh"
# 2022-03-07 | CR
# Deploy both FE/BE containers to the VPS. BTW they would be better be deploy separately.
# Check 'vps/deploy_to_vps.sh' on each of them repo.
#
set -euo pipefail
IFS=$'\n\t'

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${CURRENT_DIR}" ;

# Ensure local cleanup of temporary .env even on failure
cleanup() {
  rm -f .env || true
}
trap cleanup EXIT

# Set app version if 1st parameter is passed to this script
if [ "${1:-}" != "" ]; then
    echo "$1" > version.txt
fi

VPS_USER="ocrusr"
if [ "${2:-}" != "" ]; then
    VPS_USER="$2"
fi

VPS_NAME="vps.exampleapp.com"
if [ "${3:-}" != "" ]; then
    VPS_NAME="$3"
fi

VPS_PORT="22"
if [ "${4:-}" != "" ]; then
    VPS_PORT="$4"
fi

LOCAL_PRIVATE_KEY_PATH="~/.ssh/id_rsa_${VPS_USER}_${VPS_NAME}"
if [ "${5:-}" != "" ]; then
    LOCAL_PRIVATE_KEY_PATH="$5"
fi

VPS_DIRECTORY="~/exampleapp_start"
if [ "${6:-}" != "" ]; then
    VPS_DIRECTORY="$6"
fi

# Variables (SSH_CMD will be defined after key path is normalized)

# Generate .env
if [ -f "${CURRENT_DIR}/../k8/.env" ]; then
    set -o allexport; . "${CURRENT_DIR}/../k8/.env" ; set +o allexport ;
else
    echo "Missing file: ${CURRENT_DIR}/../k8/.env" >&2 ;
    exit 1
fi

cat > .env <<EOF
APP_REACT_APP_API_URL=${APP_BACKEND_PUBLIC_URL}:${APP_BACKEND_PORT}
APP_DB_URI=${APP_DB_URI}
APP_SECRET_KEY=${APP_SECRET_KEY}
EOF

LOCAL_KEY_REALPATH="${LOCAL_PRIVATE_KEY_PATH/#\~/$HOME}"
if [ ! -f "${LOCAL_KEY_REALPATH}" ]; then
  echo "SSH key not found: ${LOCAL_PRIVATE_KEY_PATH}" >&2
  exit 1
fi
# Apply safe permissions to the SSH key
chmod 600 "${LOCAL_KEY_REALPATH}" || true

# Build SSH command with normalized private key path
SSH_CMD="ssh -p ${VPS_PORT} -i ${LOCAL_KEY_REALPATH} -oStrictHostKeyChecking=no"

# Copy only minimum files to bring up the containers
TARGET_REMOTE_DIR="${VPS_USER}@${VPS_NAME}:${VPS_DIRECTORY}"
rsync -arv -e "${SSH_CMD}" ./.env ${TARGET_REMOTE_DIR}/
rsync -arv -e "${SSH_CMD}" ./docker-compose.yml ${TARGET_REMOTE_DIR}/
rsync -arv -e "${SSH_CMD}" ./run-server-containers.sh ${TARGET_REMOTE_DIR}/
rsync -arv -e "${SSH_CMD}" ./create_server_users_and_groups.sh ${TARGET_REMOTE_DIR}/
rsync -arv -e "${SSH_CMD}" ./Makefile ${TARGET_REMOTE_DIR}/
if [ -f version.txt ]; then
  rsync -arv -e "${SSH_CMD}" ./version.txt ${TARGET_REMOTE_DIR}/
fi

# Restart the containers on the VPS
${SSH_CMD} "${VPS_USER}@${VPS_NAME}" "sh -x ${VPS_DIRECTORY}/run-server-containers.sh down" || true
${SSH_CMD} "${VPS_USER}@${VPS_NAME}" "sh -x ${VPS_DIRECTORY}/run-server-containers.sh"

# Clean up handled by trap
