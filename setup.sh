# Updates
sudo apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove

# Install Deps
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    unzip \
    gnupg \
    gnupg-agent \
    software-properties-common \
    -y

# Define some alias for root
wget -O - https://gist.githubusercontent.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/61889c87d122ea71a7af8301196792b06b899cda/docker-aliases.sh > ~/.bash_aliases

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

curl -SL https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
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
wget https://github.com/splintnet/new-machine/archive/refs/heads/master.zip -O ./machine.zip

# Extract and tidy up
unzip machine.zip && mv new-machine-master/* ./ && rm -rf machine.zip new-machine-master

# Copy bash to www-data
cp /root/.bashrc /var/www/.bashrc
cp /root/.bash_aliases /var/www/.bash_aliases

# Correct owner
sudo chown -R www-data: /var/www

# Generate SSH Key
ssh-keygen -q -t rsa -N '' <<<""$'\n'"y" 2>&1 >/dev/null

su www-data

# Generate SSH Key for www-data
ssh-keygen -q -t rsa -N '' <<<""$'\n'"y" 2>&1 >/dev/null

# Authorize myself for CI/CD
cat /var/www/.ssh/id_rsa.pub > /var/www/.ssh/authorized_keys
