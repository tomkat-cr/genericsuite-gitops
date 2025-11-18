#!/bin/bash
# File: "scripts/create_le_ssl_cert_macos.sh"
# 2025-08-30 | CR
# Script to create a Let's Encrypt SSL certificate for a domain and install it in macOS with Homebrew.

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

brew install certbot

if ! command -v certbot &> /dev/null
then
    echo -e "${RED}Error: The Certbot installation failed. Please check the errors and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}Certbot installed correctly.${NC}\n"
sleep 2

# 3. Get and install the SSL certificate
echo -e "${GREEN}--- Step 2: Requesting the SSL certificate for ${DOMAIN}... ---${NC}"
echo -e "${YELLOW}--- IMPORTANT: this will ask for your password to have root privileges ---${NC}"

# Use --webroot to let Certbot know in which folder are the files of your website.
sudo certbot certonly --webroot -w "${REPO_BASEDIR}/nginx_router/www" -d "$DOMAIN" -m "$EMAIL" --deploy-hook "sudo cp /etc/letsencrypt/live/${DOMAIN}/* ${DESTINATION_DIR}/"

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: The certificate acquisition failed. Check the domain and NGINX configuration.${NC}"
    exit 1
fi

echo -e "${GREEN}SSL certificate installed and configured successfully for ${DOMAIN}!${NC}\n"
sleep 2

# 4. Verify the automatic renewal
echo -e "${GREEN}--- Step 3: Verifying the automatic renewal process... ---${NC}"
echo -e "${YELLOW}--- IMPORTANT: this will evenutally ask for your password to have root privileges ---${NC}"

sudo certbot renew --dry-run
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Warning: The simulation of the renewal failed. The automatic renewal may not work.${NC}"
    echo -e "${YELLOW}Make sure that port 80 is accessible for the renewal process.${NC}"
else
    echo -e "${GREEN}The simulation of the renewal was successful. The automatic renewal is configured.${NC}"
fi

# Note: Certbot on macOS doesn't have a service implementation
# Setting up automatic renewal via cron
echo ""
echo -e "${GREEN}Setting up automatic renewal via cron...${NC}"
echo -e "${YELLOW}To set up automatic renewal, you need to add a cron job manually:${NC}"
echo -e "${YELLOW}1. Open terminal and run: crontab -e${NC}"
echo -e "${YELLOW}2. Add this line to run renewal check twice daily:${NC}"
echo -e "${YELLOW}   0 12,0 * * * /usr/local/bin/certbot renew --quiet --deploy-hook \"sudo cp /etc/letsencrypt/live/${DOMAIN}/* ${DESTINATION_DIR}/\"${NC}"
echo -e "${YELLOW}3. Save and exit the editor${NC}"
echo -e "${YELLOW}This will check for renewal twice a day and copy certificates to your nginx directory when renewed.${NC}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: The certificate renewal failed. Please check the errors and try again.${NC}"
    exit 1
fi

echo -e "\n${GREEN}--- Process completed! ---${NC}"
echo -e "Your site ${GREEN}https://$DOMAIN${NC} is now secure with a Let's Encrypt SSL certificate."
echo -e "The certificate will be renewed automatically."

exit 0