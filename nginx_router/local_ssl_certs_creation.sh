#!/bin/sh
# local_ssl_certs_creation.sh
# 2025-08-21 | CR
#
REPO_BASEDIR="`pwd`"
# Script directory and change to it
SCRIPT_DIR=$(cd $(dirname $0); pwd)

install_mkcert_linux_common() {
    if ! curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
    then
        echo ""
        echo "Error downloading mkcert"
        exit 1
    fi
    if ! chmod +x mkcert-v*-linux-amd64
    then
        echo ""
        echo "Error chmod mkcert-v*-linux-amd64"
        exit 1
    fi
    if ! sudo cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert
    then
        echo ""
        echo "Error copying mkcert-v*-linux-amd64 to /usr/local/bin/mkcert"
        exit 1
    fi
}

install_mkcert_rhel() {
    if ! sudo yum install -y nss-tools curl
    then
        echo ""
        echo "Error installing nss-tools curl"
        exit 1
    fi
    install_mkcert_linux_common
}

install_mkcert_debian() {
    if ! sudo apt install -y libnss3-tools curl
    then
        echo ""
        echo "Error installing libnss3-tools curl"
        exit 1
    fi
    install_mkcert_linux_common
}

install_mkcert_macos() {
    if ! brew install mkcert
    then
        echo ""
        echo "Error installing mkcert"
        exit 1
    fi
    if ! brew install nss # if you use Firefox
    then
        echo ""
        echo "Error installing nss"
        exit 1
    fi
}

install_mkcert() {
    if apt --version > /dev/null 2>&1
    then
        install_mkcert_debian
    elif yum --version > /dev/null 2>&1
    then
        install_mkcert_rhel
    elif brew --version > /dev/null 2>&1
    then
        install_mkcert_macos
    else
        echo ""
        echo "Error: Unsupported OS"
        exit 1
    fi
}

echo ""
echo "Create auto-signed SSL certificates (crt/key)"

# Stop script on any error
set -e

# Load environment variables
if [ -f ./.env ]; then
    set -o allexport; . ./.env; set +o allexport ;
fi

# Default values

if [ "${SSL_CERT_GEN_METHOD}" = "" ]; then
    SSL_CERT_GEN_METHOD="mkcert"
fi

cd "$SCRIPT_DIR"

if [ "${APP_DOMAIN_NAME}" = "" ]; then
    echo "ERROR: APP_DOMAIN_NAME environment variable not defined"
    exit 1
fi

# Required
domain=$1
if [ "${domain}" = "" ]; then
    domain="${APP_DOMAIN_NAME}"
fi

destination_dir="$2"
if [ "${destination_dir}" = "" ]; then
    destination_dir="./ssl"
fi

# Directories
directory_csr="/tmp"
directory_key="${destination_dir}"
directory_crt="${destination_dir}"

cert_key="$directory_key/${domain}.key"
cert_crt="$directory_crt/${domain}.crt"
cert_chain="$directory_crt/${domain}.chain.crt"
cert_ca="$directory_crt/ca.crt"

if [ "${SSL_CERT_GEN_METHOD}" = "mkcert" ]; then
    # Generate and Trust a Local Certificate Authority
    # Use a tool like mkcert to create a local Certificate Authority (CA) and generate trusted SSL certificates for your development environment.
    # https://github.com/FiloSottile/mkcert

    # 1) Install mkcert in Linux:
    install_mkcert

    # 2) Install the local CA:
    mkcert -install

    # 3) Generate a certificate for the local domain name, e.g. app.exampleapp.local, in the current directory:
    mkcert -key-file "${cert_key}" -cert-file "${cert_crt}" "${domain}"

    mkcert_cert_ca_path="$(mkcert -CAROOT)/rootCA.pem"

    echo ""
    echo "Copying: '${mkcert_cert_ca_path}' to '${cert_ca}'"
    if ! cp -p "${mkcert_cert_ca_path}" "${cert_ca}"
    then
        echo ""
        echo "Error copying mkcert CA certificate"
        exit 1
    fi
    echo ""
    echo "Concatenating: '${cert_crt}' and '${cert_ca}' to '${cert_chain}'"
    if ! cat "${cert_crt}" "${cert_ca}" > "${cert_chain}"
    then
        echo ""
        echo "Error concatenating mkcert CA certificate and certificate"
        exit 1
    fi

elif [ "${SSL_CERT_GEN_METHOD}" = "office-addin-dev-certs" ]; then
    src_directory="${HOME}/.office-addin-dev-certs"

    echo "You'll be asked for your user's password to generate the SSL keys..."
    echo "Press ENTER to proceed, Ctrl-C to stop"
    read key_pressed

    if [ -d $src_directory ]; then
        rm $src_directory/localhost.key
        rm $src_directory/localhost.crt
        rm $src_directory/ca.crt
    fi

    if [[ -f $directory_crt/${domain}.chain.crt || -d $directory_crt/${domain}.chain.crt ]]; then
        rm -rf $directory_crt/${domain}.chain.crt
    fi
    if [[ -f $directory_key/${domain}.key || -d $directory_key/${domain}.key ]]; then
        rm -rf $directory_key/${domain}.key
    fi
    if [[ -f $directory_crt/${domain}.crt || -d $directory_crt/${domain}.crt ]]; then
        rm -rf $directory_crt/${domain}.crt
    fi
    if [[ -f $directory_crt/ca.crt || -d $directory_crt/ca.crt ]]; then
        rm -rf $directory_crt/ca.crt
    fi

    # npm install -D office-addin-dev-certs
    npx office-addin-dev-certs install --domains ${domain}

    cat $src_directory/localhost.crt $src_directory/ca.crt > $directory_crt/${domain}.chain.crt
    cp $src_directory/localhost.key $directory_key/${domain}.key
    cp $src_directory/localhost.crt $directory_crt/${domain}.crt
    cp $src_directory/ca.crt $directory_crt/ca.crt

else
    # Required
    commonname=$domain

    # Change to your company details
    country="US"
    state="Florida"
    locality="Fort Lauderdale"
    organization="${APP_DOMAIN_NAME}"
    organizationalunit="IT"
    email="info@$domain"

    # Optional
    password=dummypassword

    if [ -z "$domain" ]
    then
        echo "Argument not present."
        echo "Usage $0 [common name]"
        echo "E.g. $0 app.exampleapp.com"
        exit 1
    fi

    echo "Generating key request for $domain"

    # Generate a key
    openssl genrsa -des3 -passout pass:$password -out $directory_key/${domain}.key 2048

    # Remove passphrase from the key. Comment the line out to keep the passphrase
    echo "Removing passphrase from key"
    openssl rsa -in $directory_key/${domain}.key -passin pass:$password -out $directory_key/${domain}.key

    # Create the request
    echo "Creating CSR"
    openssl req -new -key $directory_key/${domain}.key -out $directory_csr/$domain.csr -passin pass:$password -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

    # Generate the cert (good for 1 years)
    echo "Generating certificate"
    openssl x509 -req -days 365 -in $directory_csr/$domain.csr -signkey $directory_key/${domain}.key -out $directory_crt/${domain}.crt 

    # Creating the ca.crt file
    echo "Creating ca.crt file"
    cp -p $directory_crt/${domain}.crt $directory_crt/ca.crt

    # Creating the chain file
    echo "Creating chain file"
    cat $directory_crt/${domain}.crt $directory_crt/ca.crt > $directory_crt/${domain}.chain.crt

    echo ""
    echo "---------------------------"
    echo "-----Below is your CSR-----"
    echo "---------------------------"
    echo "Filespec: $directory_csr/$domain.csr"
    echo "---------------------------"
    echo
    cat $directory_csr/$domain.csr
fi

echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo "Filespec: $cert_key"
echo "---------------------------"
echo
cat $cert_key

echo
echo "-----------------------------------"
echo "-----Below is your Certificate-----"
echo "-----------------------------------"
echo "Filespec: $cert_crt"
echo "-----------------------------------"
echo
cat $cert_crt 

echo
echo "-----------------------------------------"
echo "-----Below is your CA Certificate-----"
echo "-----------------------------------------"
echo "Filespec: $cert_ca"
echo "-----------------------------------------"
echo
cat $cert_ca 

echo
echo "-----------------------------------------"
echo "-----Below is your Chain Certificate-----"
echo "-----------------------------------------"
echo "Filespec: $cert_chain"
echo "-----------------------------------------"
echo
cat $cert_chain 

echo ""
echo "Done!"
echo ""
