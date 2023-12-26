#!/bin/sh

HOSTNAME=$1

if [ -z "$HOSTNAME" ]; then 
  HOSTNAME=$(hostname -I)
fi;

cilium uninstall

sudo rm -rf /etc/cni/net.d
sudo kubeadm reset
sudo ipvsadm --clear

sudo apt remove -y kubernetes-cni kubectl kubeadm kubelet docker-ce docker-ce-cli containerd.io 
sudo snap remove kubernetes-cni kubectl kubeadm kubelet docker-ce docker-ce-cli

sudo hostnamectl set-hostname $HOSTNAME

sudo rm -r ~/.kube/* /usr/local/bin/cilium /etc/docker/daemon.json
sudo iptables-save | grep -i cilium | sudo iptables -F && sudo iptables-save | grep -i cilium | sudo iptables -X
sudo iptables -n -L

sudo reboot
