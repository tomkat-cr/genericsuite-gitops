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

sh ../scripts/firewall_manager.sh open ${APP_FRONTEND_PORT}
sh ../scripts/firewall_manager.sh open ${APP_BACKEND_PORT}
