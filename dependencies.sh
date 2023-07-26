#!/bin/bash

# Update package information and install required packages
sudo apt update -y
sudo apt install debconf-utils apache2 mysql-server php libapache2-mod-php php-mysql php-redis php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
php --version
mysql --version

# Set MySQL root password without prompt
echo "mysql-server mysql-server/root_password password YourMySQLRootPassword" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password YourMySQLRootPassword" | sudo debconf-set-selections

# Install MySQL and set correct permissions
sudo apt install -y mysql-server
sudo chmod 755 /var/lib/mysql/mysql

# Enable and restart Apache and MySQL services
sudo systemctl enable apache2 mysql

# Restart MySQL service (this will apply the password we set above)
sudo systemctl restart mysql

# Create WordPress database and user
sudo mysql -u root -pYourMySQLRootPassword <<MYSQL_SCRIPT
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpressuser'@'%' IDENTIFIED WITH mysql_native_password BY 'YourStrongPassword';
GRANT ALL ON wordpress.* TO 'wordpressuser'@'%';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

sudo rm /var/www/html/index.html

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo mv wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/

# Add the Apache virtual host configuration to the file
CONFIG_CONTENT=$(cat <<EOL
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/
    ServerName your_domain.com

    <Directory /var/www/html/>
        AllowOverride All
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL
)

echo "$CONFIG_CONTENT" | sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null

# Enable the WordPress virtual host and restart Apache
sudo a2ensite wordpress.conf
sudo systemctl restart apache2
