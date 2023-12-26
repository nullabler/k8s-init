#!/bin/sh

HOSTNAME=$1

if [ -z "$HOSTNAME" ]; then 
  HOSTNAME=instance
fi;

# sudo kubeadm reset && sudo rm /etc/cni/net.d/10-calico.conflist /etc/cni/net.d/calico-kubeconfig && sudo ipvsadm --clear
# rm -r ~/.kube/*
# sudo iptables-save | grep -i cali | sudo iptables -F && sudo iptables-save | grep -i cali | sudo iptables -X
# sudo iptables -n -L

cilium cleanup

sudo rm /etc/cni/net.d/05-cilium.conf
sudo kubeadm reset
sudo ipvsadm --clear

sudo apt remove -y kubernetes-cni kubectl kubeadm kubelet docker-ce docker-ce-cli containerd.io 

sudo hostnamectl set-hostname $HOSTNAME

sudo rm $HOME/.kube/* /usr/local/bin/cilium
sudo iptables-save | grep -i cilium | sudo iptables -F && sudo iptables-save | grep -i cilium | sudo iptables -X
sudo iptables -n -L

sudo reboot
