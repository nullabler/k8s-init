#!/bin/sh

export $(cat .env.local | xargs)

HOSTNAME=$1

if [ -z "$HOSTNAME" ]; then 
  if [ -z "$K8S_HOSTNAME" ]
    echo 'Not enough arguments (missing: "HOSTNAME" or "K8S_HOSTNAME" in .env.local)'
    exit 1
  else
    HOSTNAME=$K8S_HOSTNAME
  fi
fi;

sudo apt update
sudo apt upgrade
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https vim

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
sudo mv ~/kubernetes.list /etc/apt/sources.list.d

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io kubelet kubeadm kubectl kubernetes-cni
sudo swapoff -a

sudo hostnamectl set-hostname $HOSTNAME

sudo modprobe overlay 
sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1

sudo ufw allow $K8S_UFW_PORT
sudo ufw allow $K8S_UFW_PORT/tcp
    
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable containerd
sudo systemctl restart containerd
