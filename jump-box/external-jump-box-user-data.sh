#!/bin/bash
sudo sed -i -e "s/#Port 22/Port 37689/g" /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo apt update
sudo apt install awscli -y
sudo apt install unzip
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "Script Executed"