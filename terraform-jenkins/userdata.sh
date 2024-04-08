#!/bin/bash

# Update packages & Install Docker
sudo apt-get install  ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y 
sudo groupadd docker
sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker
sudo systemctl enable docker

# Install Java JDK 11
sudo apt-get remove -y openjdk-11-jdk 
sudo apt-get install -y openjdk-11-jdk

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
sudo echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
sudo systemctl enable jenkins

# Output Jenkins URL
echo "Jenkins is running at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"


# Install Terraform
sudo apt-get -y install unzip
wget https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip
unzip terraform_1.1.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
