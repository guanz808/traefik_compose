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
  echo -e "${green}The git repolistory $TRAEFIK_COMPOSE_DIRnot found. Cloning the repository...${reset}"
  git clone --quiet -b main https://github.com/guanz808/traefik_compose.git $TRAEFIK_COMPOSE_DIR
else
  echo -e "${green}The git repository $TRAEFIK_COMPOSE_DIR already exists. Updating...${reset}"
  git -C $TRAEFIK_COMPOSE_DIR pull origin main #--quiet 
fi

###################################################################################
## Drcrypt the .env file
###################################################################################
#!/bin/bash

# Check if age is installed
echo "${green}Checking if age is installed..."

if command -v age &> /dev/null; then
  echo "${green}Age is already installed. Version:"
  age --version
else
  echo "${red}Age is not installed. Installing..."
  sudo apt-get update && sudo apt-get install -y age
  echo "${green}Installation complete. Verifying age installation..."
  if command -v age &> /dev/null; then
    echo "${green}Age installation successful. Version:"
    age --version
  else
    echo "${red}Error: Age installation failed."
  fi
fi