#!/bin/bash

# Update package lists
sudo apt update -y

# Install PHP and related dependencies
sudo apt install php libapache2-mod-php php-mysql php-redis php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

# Install Apache2 and MySQL
sudo apt install apache2 mysql-server -y

# Enable Apache2 and MySQL services
sudo chmod 755 /var/lib/mysql/mysql
sudo systemctl enable apache2 mysql
sudo systemctl restart mysql

# Download and extract the latest WordPress
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz

# Move WordPress files to the appropriate directory
sudo mkdir /var/www/wordpress
sudo cp -R wordpress/* /var/www/wordpress

# Set proper ownership and permissions
sudo chown -R www-data:www-data /var/www/wordpress
sudo chmod -R 775 /var/www/wordpress

# Log in to MySQL as root
#sudo mysql -u root
