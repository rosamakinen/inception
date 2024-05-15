#!/bin/sh

# Prepare directories and rights
echo "this is ok"
mkdir -p /var/lib/mysql /run/mysqld /var/log/mysql
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/log/mysql
chown -R mysql:mysql /var/lib/mysql

# init database
echo "this is ok too"
mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
echo "is this the prob"
# Enforce root pw, create db, add user, give rights
mysqld --user=mysql --bootstrap << EOF

USE mysql;
FLUSH PRIVILEGES;

DROP DATABASE IF EXISTS test ;

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$WORDPRESS_DB_USER'@'%' IDENTIFIED by '$WORDPRESS_DB_PASSWORD';
GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD' WITH GRANT OPTION;
GRANT SELECT ON mysql.* TO '$WORDPRESS_DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

exec mysqld --defaults-file=/etc/my.cnf.d/my.cnf
