#!/bin/bash
# File: vps/generate_client_private_key.sh
# Origin: ocr-015-install-server.sh
# Generate private key access to the server.
# IMPORTANT: This script must be executed on the local PC, not on the Server.
# 2022-03-07 | CR

createKey=1;
if [ "$1" = "" ]; then
    echo "";
    echo "First parameter is required: username.";
    echo "E.g. ocrusr";
    createKey=0;
fi
if [ "$2" = "" ]; then
    echo "";
    echo "Second parameter is required: server name/IP.";
    echo "E.g. vps.exampleapp.com";
    createKey=0;
fi

echo "";

if [ $createKey -eq 1 ]; then

    VPS_USER=$1 ;
    VPS_NAME=$2 ;
    VPS_ID_RSA_FILENAME="id_rsa_${VPS_USER}_${VPS_NAME}" ;

    # Dentro de nuestro PC local, entrar a Poweshell o CMD, y crear una llave con el comando:

    echo "" ;
    echo "PUBLIC/PRIVATE KEY CREATION FOR REMOTE SERVER" ;
    echo "This script must be executed from your local PC, not on the server." ;
    echo "" ;
    echo "User: ${VPS_USER}" ;
    echo "Server: ${VPS_NAME}" ;
    echo "" ;
    echo "The next step will create the keys." ;
    echo "Key to be created: ${VPS_ID_RSA_FILENAME}" ;
    echo "" ;
    echo "IMPORTANT: To all questions, press ENTER." ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    ssh-keygen -b 4096 ;

    echo "" ;
    echo "The keys should have been created: a public 'id_rsa.pub' and a private 'id_rsa'" ;
    echo "In the [~/$USER/.ssh] directory of your user." ;
    echo "Those files will be renamed to: ${VPS_ID_RSA_FILENAME}" ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    cd ~/.ssh ;
    mv id_rsa ${VPS_ID_RSA_FILENAME} ;
    mv id_rsa.pub ${VPS_ID_RSA_FILENAME}.pub ;

    echo "" ;
    echo "The next step will ask for your password (to have root privileges) so it can change the keys attributes:" ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    sudo chmod 600 ${VPS_ID_RSA_FILENAME} ;
    sudo chmod 600 ${VPS_ID_RSA_FILENAME}.pub ;

    echo "" ;
    echo "The keys are now:"
    echo "" ;

    ls -lah ${VPS_ID_RSA_FILENAME} ;
    ls -lah ${VPS_ID_RSA_FILENAME}.pub ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    echo "" ;
    echo "Now the public key will be uploaded to the server using 'ssh-copy-id'." ;
    echo "ssh-copy-id creates an authorized-keys file in /home/user/.sh/ on the destination server." ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    ssh-copy-id -i ${VPS_ID_RSA_FILENAME}.pub ${VPS_USER}@${VPS_NAME} ;

    echo "" ;
    echo "If there are complaints about the server footprint changing, e.g.:" ;
    echo "ERROR: @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @" ;
    echo "" ;
    echo "Run the command:" ;
    echo "   sudo nano ~/.ssh/known_hosts" ;
    echo "" ;
    echo "And delete the lines that have the IP and/or domain of the server." ;

    echo "" ;
    echo "Now the test of connecting to the server with the keys created will be made." ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    ssh -i ${VPS_ID_RSA_FILENAME} ${VPS_USER}@${VPS_NAME} ;
fi