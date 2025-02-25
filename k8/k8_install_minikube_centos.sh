#!/bin/sh
# k8/k8_install_minikube_centos.sh
# 2022-02-25 | CR

# https://phoenixnap.com/kb/install-minikube-on-centos

# General variables
OTHER_USER="$1"
OS_USER="$2"
CURRENT_DATE=`date +%Y-%m-%d`
libvirtd_bak_filename="libvirtd.conf.$CURRENT_DATE.bak"

SUDO_CMD=""
if [ $(whoami) != "root" ] ; then
    SUDO_CMD="sudo"
fi

# Step 1: Updating the System
$SUDO_CMD yum -y update

# Step 2: Installing KVM Hypervisor
# 1. Start by installing the required packages:

$SUDO_CMD yum -y install epel-release
$SUDO_CMD yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils

# 2. Then, start and enable the libvirtd service:

$SUDO_CMD systemctl start libvirtd
$SUDO_CMD systemctl enable libvirtd

# 3. Confirm the virtualization service is running with the command:

# Check KVM status.
$SUDO_CMD systemctl status libvirtd

# The output should tell you the service is active (running).

# 4. Next, add your user to the libvirt group:

$SUDO_CMD usermod -a -G libvirt $(whoami)

if [ "$OTHER_USER" != "" ] ; then
    if [ $(whoami) != $OTHER_USER ] ; then
        $SUDO_CMD usermod -a -G libvirt $(OTHER_USER)
    fi
fi
if [ "$OS_USER" != "" ] ; then
    if [ $(whoami) != $OS_USER ] ; then
        $SUDO_CMD usermod -a -G libvirt $(OS_USER)
    fi
fi

# 5. Then, open the configuration file of the virtualization service:

# vi /etc/libvirt/libvirtd.conf

# 6. Make sure that that the following lines are set with the prescribed values:

# unix_sock_group = "libvirt"
# unix_sock_rw_perms = "0770"

if [ ! -f "/etc/libvirt/$libvirtd_bak_filename" ]; then
    $SUDO_CMD cp /etc/libvirt/libvirtd.conf /etc/libvirt/${libvirtd_bak_filename}
    $SUDO_CMD echo 'unix_sock_group = "libvirt"' >> /etc/libvirt/libvirtd.conf
    $SUDO_CMD echo 'unix_sock_rw_perms = "0770"' >> /etc/libvirt/libvirtd.conf
fi

# 7. Finally, restart the service for the changes to take place:

$SUDO_CMD systemctl restart libvirtd.service

# Step 3: Installing Minikube

$SUDO_CMD yum -y install wget

# With the virtualization service enabled, you can move on to installing Minikube.

# 1. Download the Minikube binary package using the wget command:

$SUDO_CMD wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# 2. Then, use the chmod command to give the file executive permission:

$SUDO_CMD chmod +x minikube-linux-amd64

# 3. Finally, move the file to the /usr/local/bin directory:

$SUDO_CMD mv minikube-linux-amd64 /usr/local/bin/minikube

# 4. With that, you have finished setting up Minikube. Verify the installation by checking the version of the software:

# Verify Minikube installation.
/usr/local/bin/minikube version

# The output should display the version of Minikube installed on your CentOS.

# Step 4: Installing Kubectl

# 1. Run the following command to download kubectl:

$SUDO_CMD curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

# 2. Give it executive permission:

$SUDO_CMD chmod +x kubectl

# 3. Move it to the same directory where you previously stored Minikube:

$SUDO_CMD mv kubectl /usr/local/bin/

# 4. Verify the installation by running:

# Verify Kubectl installation.
/usr/local/bin/kubectl version --client -o json

# Step 5: Starting Minikube

# minikube start
/usr/local/bin/minikube start
