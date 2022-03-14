# Updates
sudo apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove

# Install Docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    unzip \
    gnupg-agent \
    software-properties-common \
    -y

# Define some alias
wget -O - https://gist.github.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/61889c87d122ea71a7af8301196792b06b899cda/docker-aliases.sh > ~/.bash_aliases

# Setup Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Setup Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Add Docker User
sudo usermod --shell /bin/bash www-data
sudo usermod -a -G docker www-data

# Create www home
sudo mkdir -p /var/www/apps
sudo chown -R www-data: /var/www
sudo usermod -d /var/www www-data

# CD to www
cd /var/www

# Download master
wget https://github.com/splintnet/new-machine/archive/refs/heads/master.zip -O machine.zip

# Extract and tidy up
unzip machine.zip && mv new-machine-master/* ./ && rm -rf machine.zip new-machine-master

# Correct owner
sudo chown -R www-data: /var/www

# Generate SSH Key
ssh-keygen -q -t rsa -N '' <<<""$'\n'"y" 2>&1 >/dev/null

su www-data

ssh-keygen -q -t rsa -N '' <<<""$'\n'"y" 2>&1 >/dev/null
