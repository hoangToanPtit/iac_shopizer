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

# Install docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo rm -rf /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
newgrp docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo service docker restart

# Setup frontend
mkdir -p /var/log/
docker pull ht04/shopizer-service:1.0.1

docker run -d \
-p 8080:8080 \
--restart always \
-v /var/log:/opt/app/logs \
ht04/shopizer-service:1.0.1