#!/bin/bash

# Paths
TRAEFIK_COMPOSE_DIR="$HOME/docker/traefik_compose"

cd $TRAEFIK_COMPOSE_DIR
chmod +x deploy_traefik_compose.sh

# Run deploy_traefik_compose.sh
./deploy_traefik_compose.sh