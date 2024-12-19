#!/bin/bash

# Colors (use predefined variables)
red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

# Paths
TRAEFIK_COMPOSE_DIR="$HOME/docker/traefik_compose"

cd $TRAEFIK_COMPOSE_DIR
chmod +x deploy_traefik_compose.sh

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

# Run deploy_traefik_compose.sh
./deploy_traefik_compose.sh