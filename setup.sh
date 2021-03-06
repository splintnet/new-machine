# Updates
sudo apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

# Install Docker

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    gnupg-agent \
    software-properties-common \
    -y
    
# Define some alias    
wget -O - https://gist.github.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/61889c87d122ea71a7af8301196792b06b899cda/docker-aliases.sh > ~/.bash_aliases

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Docker compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Add Docker User

sudo usermod --shell /bin/bash www-data
sudo usermod -a -G docker www-data

# Create www home
sudo mkdir -p /var/www/apps
sudo chown -R www-data: /var/www
sudo usermod -d /var/www www-data

# CD to it and get the infrastructure
cd /var/www

DOWNLOAD_URL=https://raw.githubusercontent.com/splintnet/new-machine/master/

mkdir -p infrastructure/loadbalancer &&
    wget "${DOWNLOAD_URL}infrastructure/loadbalancer/docker-compose.yml" -O infrastructure/loadbalancer/docker-compose.yml &&
    wget "${DOWNLOAD_URL}infrastructure/loadbalancer/start.sh" -O infrastructure/loadbalancer/start.sh &&
    cd infrastructure/loadbalancer && chmod +x start.sh && ./start.sh && cd /var/www

mkdir -p infrastructure/mysql &&
    wget "${DOWNLOAD_URL}infrastructure/mysql/docker-compose.yml" -O infrastructure/mysql/docker-compose.yml &&
    wget "${DOWNLOAD_URL}infrastructure/mysql/start.sh" -O infrastructure/mysql/start.sh &&
    cd infrastructure/mysql && chmod +x start.sh && ./start.sh && cd /var/www

mkdir -p infrastructure/redis &&
    wget "${DOWNLOAD_URL}infrastructure/redis/docker-compose.yml" -O infrastructure/redis/docker-compose.yml &&
    wget "${DOWNLOAD_URL}infrastructure/redis/start.sh" -O infrastructure/redis/start.sh &&
    cd infrastructure/redis && chmod +x start.sh && ./start.sh && cd /var/www

mkdir -p infrastructure/datadog &&
    wget "${DOWNLOAD_URL}infrastructure/datadog/docker-compose.yml" -O infrastructure/datadog/docker-compose.yml &&
    wget "${DOWNLOAD_URL}infrastructure/datadog/start.sh" -O infrastructure/datadog/start.sh &&
    cd infrastructure/datadog && chmod +x start.sh && cd /var/www

sudo chown -R www-data: /var/www

# Generate SSH Key

ssh-keygen -q -t rsa -N '' <<<""$'\n'"y" 2>&1 >/dev/null
