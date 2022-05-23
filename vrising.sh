sudo apt update && sudo apt upgrade -y 
sudo apt install unzip apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y
sudo apt update

#install docker
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo apt install docker-compose -y
sudo usermod -aG docker $USER

#clone v-rising repository and build docker image
sudo apt install git
sudo git clone https://github.com/Googlrr/V-Rising-Docker-Linux
cd V-Rising-Docker-Linux
sudo docker build . -t vrising:latest

#make serverconfig and saves and settings
sudo mkdir /usr/games/serverconfig
sudo mkdir /usr/games/serverconfig/vrising/saves
sudo mv ./settings /usr/games/serverconfig/vrising/settings

#install vrising app on docker
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
crontab -l | { cat; echo "@reboot root (cd /usr/games/serverconfig/ && docker-compose up)"; } | crontab -
sudo docker-compose up
