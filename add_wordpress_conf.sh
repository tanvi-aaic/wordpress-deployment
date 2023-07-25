#!/bin/bash

# Configuration content to be added
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

# Write the configuration content to the file
echo "$CONFIG_CONTENT" | sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null
