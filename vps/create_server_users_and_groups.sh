#!/bin/bash
# File: "vps/create_server_users_and_groups.sh"
# Origin: "ocr-010-install-server.sh"
# Create the user ubuntu/centos/ocrusr, group ocrgroup, add it to the group of sudoers and docker.
# IMPORTANT: This script must be executed on the Server.
# 2022-03-09 | CR

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

# Stop on any error
set -e

# Get the distro name and type
. "../scripts/get_os_name_type.sh" ;
ERROR_MSG="";
if  [ "$OS_NAME_LOWERCASED" = "" ]; then
    ERROR_MSG="$ERROR_MSG OS_NAME_LOWERCASED";
fi
if  [ "$ID_LIKE" = "" ]; then
    ERROR_MSG="$ERROR_MSG ID_LIKE";
fi
if  [ "$OS_VERSION" = "" ]; then
    ERROR_MSG="$ERROR_MSG OS_VERSION";
fi
if [ "$ERROR_MSG" != "" ]; then
    echo "Error [1]: Missing variable(s): $ERROR_MSG";
    exit 1;
fi

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
	SUDO_CMD="sudo"
fi

echo "";
echo "CREATING THE MAIN USER IN THE CURRENT LINUX DISTRO";
echo "Linux Distro [$OS_NAME_LOWERCASED], version [$OS_VERSION], ID like [$ID_LIKE]";

export ocr_user=$OS_NAME_LOWERCASED ;
if [ "$1" != "" ]; then
    export ocr_user=$1 ;
fi
export ocr_group="ocrgroup" ;
if [ "$ID_LIKE" = "debian" ]; then
    export sudoers_group="sudo" ;
else
    export sudoers_group="wheel" ;
fi
export docker_group="docker" ;

echo "";
echo "The user to be created is [$ocr_user] in the group [$ocr_group].";
echo "Additionally, the user will be added to the groups [$sudoers_group] and [$docker_group].";
echo "Then a new password will be asked for the user [$ocr_user].";
echo "Please remember to take note of that password.";

echo "";
read -p "Do you agree with these data (y/n)? " answer ;#
answer=$(echo "$answer" | awk '{print tolower($0)}') ;
if [ $answer = "y" ]
then
	echo ""
	echo "'$ocr_group' group creation..."
	$SUDO_CMD groupadd $ocr_group ;
	echo ""
	echo "'$docker_group' group creation..."
	$SUDO_CMD groupadd $docker_group ;
	echo ""
	echo "'$ocr_user' user creation in the '$ocr_group' group..."
	$SUDO_CMD useradd -g $ocr_group -d /home/$ocr_user -m $ocr_user ;
	echo ""
	echo "Add user '$ocr_user' to the '$docker_group' group..."
	$SUDO_CMD usermod -a -G $docker_group $ocr_user;
	echo ""
	echo "~/Downloads directory creation..."
	$SUDO_CMD mkdir -p /home/$ocr_user/Downloads ;
	# Allow members of group sudo to execute any command
	# In ubuntu, the group is "sudo", in RHEL is "wheel" and it must be activated with "visudo"
	# For more information, see:
	# 2.3. Configuring sudo Access (sudoers)
	# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux_OpenStack_Platform/2/html/Getting_Started_Guide/ch02s03.html
	echo ""
	echo "Allow members of group '$sudoers_group' to execute any command..."
	$SUDO_CMD usermod -a -G $sudoers_group $ocr_user;
	echo ""
	echo "Please enter a new the password of the user [$ocr_user]:";
	$SUDO_CMD passwd $ocr_user;
	echo "";
	echo "Done... User [$ocr_user] and group [$ocr_group] have been created.";
	echo "The user [$ocr_user] belongs to these groups:";
	groups $ocr_user ;
	echo "";
fi
