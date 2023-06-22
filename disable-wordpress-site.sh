#!/bin/bash

# Check if a site name is provided as a command-line argument
if [ -z "$1" ]; then
  echo "Please provide the site name as a command-line argument."
  exit 1
fi

# Set the site name
site_name="$1"

# Stop the containers
cd "$site_name"
docker-compose stop

# Remove the containers
docker-compose rm -f

echo "Site disabled and containers removed successfully."
