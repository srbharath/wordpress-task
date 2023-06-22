#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if docker and docker-compose are installed
if ! command_exists docker || ! command_exists docker-compose; then
  echo "Docker or Docker Compose is not installed. Please install them and try again."
  exit 1
fi

# Check if a site name is provided as a command-line argument
if [ -z "$1" ]; then
  echo "Please provide a site name as a command-line argument."
  exit 1
fi

# Set the site name
site_name="$1"

# Create a /etc/hosts entry for example.com
sudo sed -i "/$site_name/d" /etc/hosts
echo "127.0.0.1  $site_name" | sudo tee -a /etc/hosts > /dev/null

# Create a directory for the WordPress site
mkdir "$site_name"
cd "$site_name"

# Create a docker-compose.yml file for LEMP stack
cat <<EOF > docker-compose.yml
version: '3'
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress_password
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - 80:80
    volumes:
      - ./wp-content:/var/www/html/wp-content
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress_password
  nginx:
    image: nginx:latest
    ports:
      - 8080:80
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - wordpress
volumes:
  db_data:
EOF

# Create an Nginx configuration file
cat <<EOF > nginx.conf
server {
    listen 80;
    server_name $site_name;

    location / {
        proxy_pass http://wordpress:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

EOF

# Start the containers
docker-compose up -d

# Wait for the WordPress site to be up and healthy
until $(curl --output /dev/null --silent --head --fail http://$site_name); do
  sleep 5
done

# Prompt the user to open example.com in a browser
echo "WordPress site created successfully."
echo "Open http://$site_name in a browser to access your site."
