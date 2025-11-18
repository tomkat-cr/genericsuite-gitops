#!/bin/bash
# File: vps/generate_client_private_key.sh
# Origin: ocr-015-install-server.sh
# Generate private key access to the server.
# IMPORTANT: This script must be executed on the local PC, not on the Server.
# 2022-03-07 | CR

set -euo pipefail
IFS=$'\n\t'

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

    # Create the key directly at the final path to avoid renames
    ssh-keygen -b 4096 -f "${HOME}/.ssh/${VPS_ID_RSA_FILENAME}" -C "${VPS_USER}@${VPS_NAME}" || true

    echo "" ;
    echo "The keys should have been created in [${HOME}/.ssh]:" ;
    echo "- ${VPS_ID_RSA_FILENAME} (private)" ;
    echo "- ${VPS_ID_RSA_FILENAME}.pub (public)" ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    cd "${HOME}/.ssh" ;

    echo "" ;
    echo "The next step will set secure permissions on the keys:" ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    if ! chmod 600 "${VPS_ID_RSA_FILENAME}" ; then
        echo "ERROR: The private key could not be set to secure permissions." ;
        exit 1 ;
    fi
    if ! chmod 644 "${VPS_ID_RSA_FILENAME}.pub" ; then
        echo "ERROR: The public key could not be set to secure permissions." ;
        exit 1 ;
    fi

    echo "" ;
    echo "The keys are now:"
    echo "" ;

    ls -lah "${VPS_ID_RSA_FILENAME}" ;
    ls -lah "${VPS_ID_RSA_FILENAME}.pub" ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    echo "" ;
    echo "Now the public key will be uploaded to the server using 'ssh-copy-id'." ;
    echo "ssh-copy-id creates/updates the authorized_keys file in /home/<user>/.ssh/ on the destination server." ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    ssh-copy-id -i "${VPS_ID_RSA_FILENAME}.pub" "${VPS_USER}@${VPS_NAME}" ;

    echo "" ;
    echo "If there are complaints about the server footprint changing, e.g.:" ;
    echo "ERROR: @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @" ;
    echo "" ;
    echo "Run the command:" ;
    echo "   nano ~/.ssh/known_hosts" ;
    echo "" ;
    echo "And delete the lines that have the IP and/or domain of the server." ;

    echo "" ;
    echo "Now the test of connecting to the server with the keys created will be made." ;

    echo "" ;
    echo "Press ENTER to continue or Ctrl-C to cancel." ;
    read answer ;
    echo "";

    ssh -i "${VPS_ID_RSA_FILENAME}" "${VPS_USER}@${VPS_NAME}" ;
fi