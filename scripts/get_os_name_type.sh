#!/bin/sh
# File: "scripts/get_os_name_type.sh"
# 2022-03-09 | CR

# https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script
# To get OS and VER, the latest standard seems to be /etc/os-release. 
# Before that, there was lsb_release and /etc/lsb-release. 
# Before that, you had to look for different files for each distribution.
# Here's what I'd suggest

# Verify the Linux distro
if [ -f /etc/os-release ]; then
    # https://www.freedesktop.org/software/systemd/man/latest/os-release.html
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
    ID_LIKE=$ID_LIKE
    if [ "$ID_LIKE" = "" ]; then
        # It's one of main distros (debian, rhel, fedora, etc.)
        ID_LIKE=$ID
    fi
else
    echo "This script only works on Linux distros with /etc/os-release"
    exit 1
fi

# if [ -f /etc/os-release ]; then
#     # freedesktop.org and systemd
#     . /etc/os-release
#     OS=$NAME
#     VER=$VERSION_ID
# 	if [ "$OS" = "CentOS Linux" ]; then
# 		if [ "$ID" != "" ]; then
#             OS=$ID
# 		fi
# 	fi
# elif type lsb_release >/dev/null 2>&1; then
#     # linuxbase.org
#     OS=$(lsb_release -si)
#     VER=$(lsb_release -sr)
# elif [ -f /etc/lsb-release ]; then
#     # For some versions of Debian/Ubuntu without lsb_release command
#     . /etc/lsb-release
#     OS=$DISTRIB_ID
#     VER=$DISTRIB_RELEASE
# elif [ -f /etc/debian_version ]; then
#     # Older Debian/Ubuntu/etc.
#     OS=Debian
#     VER=$(cat /etc/debian_version)
# elif [ -f /etc/SuSe-release ]; then
#     # Older SuSE/etc.
#     ...
# elif [ -f /etc/redhat-release ]; then
#     # Older Red Hat, CentOS, etc.
#     ...
# else
#     # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
#     OS=$(uname -s)
#     VER=$(uname -r)
# fi


if [ "$ID" = 'debian' ]; then
    export OS_TYPE="debian"
elif [ "$ID" = 'rhel' ]; then
    export OS_TYPE="rhel"
elif [ "$ID" = 'fedora' ]; then
    export OS_TYPE="rhel"
elif [ "$(echo $ID_LIKE | grep debian)" != '' ]; then
    export OS_TYPE="debian"
elif [ "$(echo $ID_LIKE | grep rhel)" != '' ]; then
    export OS_TYPE="rhel"
elif [ "$(echo $ID_LIKE | grep centos)" != '' ]; then
    export OS_TYPE="rhel"
elif [ "$(echo $ID_LIKE | grep fedora)" != '' ]; then
    export OS_TYPE="rhel"
else
    echo "Linux distro [$ID_LIKE] is not supported"
    exit 1
fi

export OS_NAME=$OS;
export OS_NAME_LOWERCASED=$(echo "$OS" | awk '{print tolower($0)}') ;
export OS_VERSION=$VER;
export ID_LIKE=$(echo "$ID_LIKE" | awk '{print tolower($0)}') ;

echo ""
echo "OS_NAME: $OS_NAME" ;
echo "OS_NAME_LOWERCASED: $OS_NAME_LOWERCASED" ;
echo "ID_LIKE: $ID_LIKE" ;
echo "OS_TYPE: $OS_TYPE" ;
echo "OS_VERSION: $OS_VERSION" ;
