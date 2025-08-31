#!/bin/bash
# File: "scripts/create_le_ssl_cert_debian.sh"
# 2025-08-30 | CR
# Script to create a Let's Encrypt SSL certificate for a domain and install it in Debian/Ubuntu with NGINX.

cd "`dirname "$0"`"
SCRIPTS_DIR="`pwd`"
cd ..
REPO_BASEDIR="`pwd`"

if [ "${DESTINATION_DIR}" = "" ]; then
    # Default destination directory is nginx_router/ssl
    DESTINATION_DIR="${REPO_BASEDIR}/nginx_router/ssl"
fi

# Colors for the output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color

# 1. Ask for the domain and email
echo -e "${YELLOW}Please enter your domain name (e.g: ejemplo.com):${NC}"
read -r DOMAIN
echo -e "${YELLOW}Now, enter your email (for renewal notifications):${NC}"
read -r EMAIL

# Validate that the domain and email are not empty
if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo -e "${RED}The domain name and email cannot be empty. Aborting.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Perfect. A certificate will be installed for ${DOMAIN} and ${EMAIL} will be used for notifications.${NC}\n"
sleep 3

# 2. Update the system and install dependencies
echo -e "${GREEN}--- Step 1: Updating the system and installing Certbot... ---${NC}"
echo -e "${YELLOW}--- IMPORTANT: this will ask for your password to have root privileges ---${NC}"

sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

if ! command -v certbot &> /dev/null
then
    echo -e "${RED}Error: The Certbot installation failed. Please check the errors and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}Certbot installed correctly.${NC}\n"
sleep 2

# 3. Get and install the SSL certificate
echo -e "${GREEN}--- Step 2: Requesting the SSL certificate for ${DOMAIN}... ---${NC}"
echo -e "${YELLOW}--- IMPORTANT: this will eventually ask for your password to have root privileges ---${NC}"

# Use --non-interactive to prevent the script from stopping to ask for confirmation
# --agree-tos accept the terms of service
# --redirect configure NGINX to redirect HTTP to HTTPS automatically
sudo certbot --nginx --non-interactive --agree-tos -d "$DOMAIN" -m "$EMAIL" --redirect

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: The certificate acquisition failed. Check the domain and NGINX configuration.${NC}"
    exit 1
fi

echo -e "${GREEN}SSL certificate installed and configured successfully for ${DOMAIN}!${NC}\n"
sleep 2

# 4. Verify the automatic renewal
echo -e "${GREEN}--- Step 3: Verifying the automatic renewal process... ---${NC}"
echo -e "${YELLOW}--- IMPORTANT: this will eventually ask for your password to have root privileges ---${NC}"

sudo certbot renew --dry-run

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Warning: The simulation of the renewal failed. The automatic renewal may not work.${NC}"
    echo -e "${YELLOW}Make sure that port 80 is accessible for the renewal process.${NC}"
else
    echo -e "${GREEN}The simulation of the renewal was successful. The automatic renewal is configured.${NC}"
fi

echo -e "\n${GREEN}--- Process completed! ---${NC}"
echo -e "Your site ${GREEN}https://$DOMAIN${NC} is now secure with a Let's Encrypt SSL certificate."
echo -e "The certificate will be renewed automatically."

exit 0