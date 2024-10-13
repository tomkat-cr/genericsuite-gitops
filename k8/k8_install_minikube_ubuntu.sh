#!/bin/sh
# k8/k8_install_minikube_ubuntu.sh
# 2024-10-13 | CR

# https://phoenixnap.com/kb/install-minikube-on-ubuntu

# General variables
OTHER_USER="$1"
OS_USER="$2"

# Step 1: Updating the System
apt update -y
apt upgrade -y
apt install -y curl apt-transport-https wget

# Step 2: Install VirtualBox Hypervisor

apt install virtualbox virtualbox-ext-pack

# The output should tell you the service is active (running).

# 4. Next, add your user to the virtualbox group:

# usermod -a -G virtualbox $(whoami)
# if [ $(whoami) != $OTHER_USER ] ; then
#     usermod -a -G virtualbox $(OTHER_USER)
# fi

# Step 3: Installing Minikube

# 1. Download the Minikube binary package using the wget command:

wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# 2. Move the file to the /usr/local/bin directory:

mv minikube-linux-amd64 /usr/local/bin/minikube

# 3. Then, use the chmod command to give the file executive permission:

chmod 755 /usr/local/bin/minikube

# 4. With that, you have finished setting up Minikube. Verify the installation by checking the version of the software:

# Verify Minikube installation.
/usr/local/bin/minikube version

# The output should display the version of Minikube installed on your CentOS.

# Step 4: Installing Kubectl

# 1. Run the following command to download kubectl:

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

# 2. Give it executive permission:

chmod +x kubectl

# 3. Move it to the same directory where you previously stored Minikube:

mv ./kubectl /usr/local/bin/kubectl

# 4. Verify the installation by running:

# Verify Kubectl installation.
/usr/local/bin/kubectl version -o json

# Step 5: Starting Minikube

# minikube start
/usr/local/bin/minikube start
