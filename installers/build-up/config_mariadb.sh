#!/bin/bash

DB_ENDPOINT="localhost"
DB_USER="codeuser"
DB_PASS="codepass"

function provision_db {
    echo -e "\nProvisioning Database .....\n"
    mysql -e "
    CREATE DATABASE IF NOT EXISTS devopstravel;
    CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_ENDPOINT' IDENTIFIED BY '$DB_PASS';
    GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'$DB_ENDPOINT';
    FLUSH PRIVILEGES;
    SHOW DATABASES;
    "
}

function replace_passwords {
    echo -e "\nReplacing Database password .....\n"
    sed -i 's/""/"'$DB_PASS'"/g' /var/www/html/config.php
    systemctl reload apache2
    cat /var/www/html/config.php
}

function import_sql_script {
    echo -e "\nImporting Database script .....\n"

    devopstravel_sql="./bootcamp-devops-2023/app-295devops-travel/database/devopstravel.sql"
    mysql < $devopstravel_sql
    
    mysql -e "
    USE devopstravel;
    SHOW TABLES;
    "
}
