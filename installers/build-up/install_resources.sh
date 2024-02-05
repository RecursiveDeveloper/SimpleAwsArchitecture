#!/bin/bash

function install_git {
    echo -e "\n------------- Installing git\n"
    apt -y install git
    echo -e "\n$(git --version)\n"
}

function install_apache {
    echo -e "\n------------- Installing apache\n"
    apt install -y apache2
    ufw allow in "Apache"
    ufw status
    systemctl start apache2
    systemctl enable apache2

    . ./build-up/config_apache.sh; config_apache_documents
}

function install_mariadb {
    echo -e "\n------------- Installing mariadb\n"
    apt -y install mariadb-server
    systemctl start mariadb.service
    systemctl enable mariadb
    echo -e "\n$(mariadb -V)\n"

    . ./build-up/config_mariadb.sh; provision_db
}

function install_php {
    echo -e "\n------------- Installing php\n"
    apt install -y php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl
    echo -e "\n$(php -v)\n"
}

function check_packages {
    apt update -y

    if dpkg -s "git" > /dev/null 2>&1; then
        echo "Git is already installed"
    else
        install_git
    fi

    if dpkg -s "apache2" > /dev/null 2>&1; then
        echo "Apache is already installed"
    else
        install_apache
    fi

    if dpkg -s "mariadb-server" > /dev/null 2>&1; then
        echo "MariaDB is already installed";
    else
        install_mariadb
    fi

    if dpkg -s "php" "libapache2-mod-php" "php-mysql" "php-mbstring" "php-zip" "php-gd" "php-json" "php-curl" > /dev/null 2>&1; then
        echo "Php is already installed"
    else
        install_php
    fi
}

check_packages
