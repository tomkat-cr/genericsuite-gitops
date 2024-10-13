#!/bin/sh
# File: k8/open_fw_app_ports.sh
# 2022-02-25 | CR
#
# Open up port 3001 [FE] on the firewall (one time only)
# Open up port 5000 [BE] on the firewall (one time only)

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

. ./get_defaults.sh

. "../scripts/get_os_name_type.sh" ;

if [ "$OS_TYPE" = "debian" ]; then
    sudo ufw allow ${APP_FRONTEND_PORT}/tcp
    sudo ufw allow ${APP_BACKEND_PORT}/tcp
    sudo ufw reload
elif [ "$OS_TYPE" = "rhel" ]; then
    sudo firewall-cmd --zone=public --add-port=${APP_FRONTEND_PORT}/tcp --permanent
    sudo firewall-cmd --zone=public --add-port=${APP_BACKEND_PORT}/tcp --permanent
    sudo firewall-cmd --reload
else
    echo "Linux distro [$OS_TYPE] is not supported"
    exit 1
fi
