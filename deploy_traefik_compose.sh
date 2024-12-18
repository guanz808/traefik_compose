#!/bin/bash

# Colors (use predefined variables)
red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

# Paths
TRAEFIK_COMPOSE_DIR="$HOME/docker/traefik_compose"

###################################################################################
## Clone the Github repository
###################################################################################
# Clone traefik_compose repository (if not already present)
if [ ! -d $TRAEFIK_COMPOSE_DIR ]; then
  echo -e "${green}The git repolistory $TRAEFIK_COMPOSE_DIR not found. Cloning the repository...${reset}"
  git clone --quiet -b main https://github.com/guanz808/traefik_compose.git $TRAEFIK_COMPOSE_DIR
else
  echo -e "${green}The git repository $TRAEFIK_COMPOSE_DIR already exists. Updating...${reset}"
  git -C $TRAEFIK_COMPOSE_DIR pull origin main #--quiet 
fi

###################################################################################
## Install age (if not already present) - age is used to encrypt/decrypt files
###################################################################################
# Check if age is installed
echo -e "${green}Checking if age is installed...${reset}"

if command -v age &> /dev/null; then
  echo -e "${green}Age is already installed. Version:${reset}"
  age --version
else
  echo -e "${red}Age is not installed. Installing...${reset}"
  sudo apt-get update && sudo apt-get install -y age
  echo -e "${green}Installation complete. Verifying age installation...${reset}"
  if command -v age &> /dev/null; then
    echo -e "${green}Age installation successful. Version:${reset}"
    age --version
  else
    echo -e "${red}Error: Age installation failed.${reset}"
  fi
fi

###################################################################################
## Drcrypt the .env-encrypted file
###################################################################################
# Check if .env-encrypted file exists
echo -e "${green}Checking for .env-encrypted file...${reset}"
cd $TRAEFIK_COMPOSE_DIR

if [ -f ".env-encrypted" ]; then
  echo -e "${green}.env-encrypted file found! Decrypting...${reset}"
  age -d .env-encrypted > .env
  echo -e "${green}Decryption successful! .env file generated.${reset}"
else
  echo -e "${red}Error: .env-encrypted file not found.${reset}"
fi

###################################################################################
## Drcrypt the cf_api_token.txt-encrypted file
###################################################################################
# Check if cf_api_token.txt-encrypted file exists
echo -e "${green}Checking for cf_api_token.txt-encrypted file...${reset}"
cd $TRAEFIK_COMPOSE_DIR

if [ -f "cf_api_token.txt-encrypted" ]; then
  echo -e "${green}cf_api_token.txt-encrypted file found! Decrypting...${reset}"
  age -d cf_api_token.txt-encrypted > cf_api_token.txt
  echo -e "${green}Decryption successful! cf_api_token.txt file generated.${reset}"
else
  echo -e "${red}Error: cf_api_token.txt-encrypted file not found.${reset}"
fi

###################################################################################
## Check for acme.json file
###################################################################################
# Check if acme.json file exists in /data
echo -e "${green}Checking for acme.json file in /data...${reset}"
cd $TRAEFIK_COMPOSE_DIR/data

if [ -f "acme.json" ]; then
  echo -e "${green}acme.json file already exists in /data.${reset}"
else
  echo -e "${red}acme.json file not found in /data. Creating...${reset}"
  touch acme.json
  echo -e "${green}acme.json file created successfully.${reset}"
fi

# Set permissions to 600
echo -e "${green}Setting permissions to 600...${reset}"
chmod 600 acme.json
echo -e "$Permissions set to 600 successfully.${reset}"

# Verify permissions
echo -e "${green}Verifying permissions...${reset}"
ls -l acme.json | grep "rw-------"
if [ $? -eq 0 ]; then
  echo -e "${green}Permissions verified successfully.${reset}"
else
  echo -e "${red}Error: Permissions not set correctly.${reset}"
fi

###################################################################################
## Start the Docker Compose stack
###################################################################################
# Start the Docker stack
echo -e "${green}Starting Docker stack...#${reset}"
cd $TRAEFIK_COMPOSE_DIR
docker compose up -d --force-recreate

# Wait for the stack to start
echo -e "${green}Waiting for the stack to start...${reset}"
sleep 5

# Check if the stack is running
echo -e "${green}Checking if the stack is running...${reset}"
stack_status=$(docker ps traefik --format "{{.CurrentState}}" | head -n 1)

if [ "$stack_status" == "Running" ]; then
  echo -e "${green}Stack is running!${reset}"
else
  echo -e "${red}Error: Stack is not running. Status: $stack_status${reset}"
fi