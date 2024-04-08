#!/bin/bash

#  Set hostname on Each Node

sudo hostnamectl set-hostname "k8smaster.example.net"
exec bash

IP_ADDRESS=$(hostname -I | awk '{print $1}')

DOMAIN_NAME="k8smaster.example.net k8smaster"

echo "$IP_ADDRESS    $DOMAIN_NAME" | sudo tee -a /etc/hosts

# Disable swap & Add kernel Parameters

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf <<EOT
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOT

sudo sysctl --system

# CRI-O install

sudo apt update -y

sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y

export OS=xUbuntu_22.04
export CRIO_VERSION=1.24

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /"| sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION/$OS/Release.key | sudo apt-key add -

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key add -

sudo apt update -y

sudo apt install cri-o cri-o-runc -y

sudo systemctl start crio
sudo systemctl enable crio

sudo apt install containernetworking-plugins -y

sudo systemctl restart crio

sudo apt install -y cri-tools

sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock version

# Add Apt Repository for Kubernetes

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --control-plane-endpoint=k8smaster.example.net

sleep 20s

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl cluster-info

kubectl taint nodes --all node-role.kubernetes.io/control-plane-
