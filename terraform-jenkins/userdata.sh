#!/bin/bash

# Update packages
sudo apt-get update -y

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
