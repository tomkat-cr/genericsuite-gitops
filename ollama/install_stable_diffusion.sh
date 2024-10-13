#!/bin/bash
# File: ollama/install_stable_diffusion.sh
# Stable Diffusion Install
# 2024-10-13 | CR

# Reference:
# https://ntck.co/ep_401

REPO_BASEDIR="`pwd`"
cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"

get_os_data() {
    SUDO_CMD=""
    if [ $(whoami) != "root" ] ; then
        SUDO_CMD="sudo"
    fi
    if ! . "../scripts/get_os_name_type.sh"
    then
        echo ""
        echo "Error: Could not get the OS name and type"
        exit 1
    fi
}

# General variables

get_os_data $1 ;
PYTHON_VERSION_TO_INSTALL="3.10"

echo ""
echo "Prepare installation directory"

cd $HOME
if ! mkdir -p "$HOME/stable-diffusion"
then
    echo "Error: Could not create the stable-diffusion directory"
    exit 1
fi
cd "$HOME/stable-diffusion"

# Prereqs

echo ""
echo "Install Pyenv prereqs"
echo ""

if [ "$OS_TYPE" = "debian" ]; then
    $SUDO_CMD apt install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
        libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git
elif [ "$OS_TYPE" = "rhel" ]; then
    $SUDO_CMD yum install -y make automake gcc gcc-c++ kernel-devel cmake \
        git openssl-devel bzip2-devel readline-devel sqlite-devel xz xz-devel \
        zlib-devel xz-devel tk-devel libffi-devel ncurses-devel
else
    echo "This script only works on debian or rhel distros"
    exit 1
fi

echo ""
echo "Install Pyenv"
echo ""

rm -rv $HOME/.pyenv
if ! curl https://pyenv.run | bash
then
    echo "Error: Could not install Pyenv"
    exit 1
fi

echo ""
echo "Initialize Pyenv"

export PYENV_ROOT="$HOME/.pyenv"
[ -d $PYENV_ROOT/bin ] && export PATH="$PYENV_ROOT/bin:$PATH"

if ! eval "$(pyenv init -)"
then
    echo "Error: Could not initialize pyenv"
    exit 1
fi

echo ""
echo "Install requested Python version: $PYTHON_VERSION_TO_INSTALL"
echo ""

if ! pyenv install $PYTHON_VERSION_TO_INSTALL
then
    echo "Error: Could not install Python $PYTHON_VERSION_TO_INSTALL"
    exit 1
fi

echo ""
echo "Make python $PYTHON_VERSION_TO_INSTALL global"
echo ""

pyenv global $PYTHON_VERSION_TO_INSTALL

echo ""
echo "Install Stable Diffusion"
echo ""

if ! wget -q https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
then
    echo "Error: Could not download the webui.sh script"
    exit 1
fi

echo ""
echo "Make Stable Diffusion executable"

chmod +x webui.sh

echo ""
echo "Run Stable Diffusion"
echo ""

if ! $SUDO_CMD ./webui.sh --listen --api
then
    echo "Error: Could not run Stable Diffusion"
    exit 1
fi

echo ""
echo "Stable Diffusion installed successfully"
