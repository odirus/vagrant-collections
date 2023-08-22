#! /bin/bash

MASTER_IP=$(grep master /etc/hosts | tail -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
NODENAME=$(hostname -s)
SERVICE_CIDR="172.21.0.0/20"
POD_CIDR="172.20.0.0/16"
KUBE_VERSION=v1.24.6

# kubeadm init
sudo kubeadm init \
  --kubernetes-version=$KUBE_VERSION \
  --apiserver-advertise-address=$MASTER_IP \
  --image-repository=registry.aliyuncs.com/google_containers \
  --service-cidr=$SERVICE_CIDR \
  --pod-network-cidr=$POD_CIDR \
  --node-name=$NODENAME \
  --ignore-preflight-errors=Swap

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# save configs
config_path="/vagrant/configs"

if [ -d $config_path ]; then
   sudo rm -f $config_path/*
else
   sudo mkdir -p $config_path
fi

sudo cp -i /etc/kubernetes/admin.conf $config_path/config
sudo touch $config_path/join.sh
sudo chmod +x $config_path/join.sh       

kubeadm token create --print-join-command > $config_path/join.sh

# install heml
sudo tar -zxvf /vagrant/host_configs/helm-v3.9.0-linux-arm64.tar.gz
sudo mv linux-arm64/helm /usr/local/bin

# istio
tar -xzvf /vagrant/host_configs/istio-1.16.0-linux-arm64.tar.gz

# install calico
helm install calico /vagrant/host_configs/chart/calico/tigera-operator-v3.23.1.tgz -n kube-system  --create-namespace -f /vagrant/host_configs/chart/calico/values.yaml

# install metrics-server
sudo kubectl apply -f /vagrant/host_configs/metrics-server-v0.63.yaml

sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF

sudo apt-get install -y bash-completion
echo  >> .bashrc
echo 'source <(kubectl completion bash)' >> .bashrc
