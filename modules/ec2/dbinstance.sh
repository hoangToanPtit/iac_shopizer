#!/bin/bash

# Change default username
echo "Change default username"
user=shopizer
usermod  -l $user ubuntu
groupmod -n $user ubuntu
usermod  -d /home/$user -m $user
if [ -f /etc/sudoers.d/90-cloudimg-ubuntu ]; then
mv /etc/sudoers.d/90-cloudimg-ubuntu /etc/sudoers.d/90-cloud-init-users
fi
perl -pi -e "s/ubuntu/$user/g;" /etc/sudoers.d/90-cloud-init-users

# Change default port
echo "Change default port"
sudo perl -pi -e 's/^#?Port 22$/Port 2222/' /etc/ssh/sshd_config service
sudo systemctl restart sshd

# Install mysql

echo "installing mysql"
sudo apt update
sudo apt install -y mysql-server

# start mysql
sudo systemctl start mysql
sudo systemctl enable mysql

# waiting for mysql start
sleep 5

# root password
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'shopizer';"

# create database, username, password
sudo mysql -u root -p"shopizer" -e "CREATE USER 'shopizer'@'%' IDENTIFIED BY 'shopizer';"
sudo mysql -u root -p"shopizer" -e "CREATE DATABASE SALESMANAGER;"
sudo mysql -u root -p"shopizer" -e "GRANT ALL PRIVILEGES ON YOUR_DATABASE_NAME.* TO 'shopizer'@'%';"
sudo mysql -u root -p"shopizer" -e "FLUSH PRIVILEGES;"

# allow remote access
sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql