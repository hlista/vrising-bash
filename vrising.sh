# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

sudo apt update && sudo apt upgrade -y 
sudo apt install unzip apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y
sudo apt update

#install AWS CLI
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

#create random string for password
VHPW=$(echo $RANDOM | md5sum | head -c 20)

#get stackname created by user data script and update SSM parameter name with this to make it unique
STACKNAME=$(</tmp/mcParamName.txt)
PARAMNAME=mcValheimPW-$STACKNAME

#put random string into parameter store as encrypted string value
aws ssm put-parameter --name $PARAMNAME --value $VHPW --type "SecureString" --overwrite

#install docker
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo apt install docker-compose -y
sudo usermod -aG docker $USER

#clone v-rising repository and build docker image
sudo apt install git
git clone https://github.com/Googlrr/V-Rising-Docker-Linux
cd V-Rising-Docker-Linux
sudo docker build . -t vrising:latest

#install vrising app on docker
sudo mkdir /usr/games/serverconfig
cd /usr/games/serverconfig
sudo bash -c 'echo "version: \"2.1\"
services: 
  vrising:
    container_name: vrising-server
    image: vrising:latest
    volumes: 
      - ./vrising/saves:/root/.wine/drive_c/users/root/AppData/LocalLow/Stunlock Studios/VRisingServer/Saves
      - ./vrising/settings:/root/.wine/drive_c/users/root/AppData/LocalLow/Stunlock Studios/VRisingServer/Settings/
    ports: 
      - "27015:27015/udp"
      - "27016:27016/udp"
    restart: unless-stopped
    tty: true" >> docker-compose.yml'
echo "@reboot root (cd /usr/games/serverconfig/ && docker-compose up)" > /etc/cron.d/awsgameserver
sudo docker-compose up
