#!/bin/bash

function config_apache_documents {
    echo -e "\nConfiguring Apache for PHP static web page .....\n"
    local apache_path="/var/www/html"
    local apache_config_file="/etc/apache2/mods-enabled/dir.conf"
    local USER="ubuntu"
    
    chown -R $USER:$USER /var/www/

    if test -f "$apache_path/index.html"; then
        mv $apache_path/index.html $apache_path/index.html.bkp
    fi

cat << EOF > $apache_config_file
 <IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF

    systemctl reload apache2
}
