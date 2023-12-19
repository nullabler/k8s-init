#!/bin/sh

sudo kubeadm reset && sudo rm /etc/cni/net.d/10-calico.conflist /etc/cni/net.d/calico-kubeconfig && sudo ipvsadm --clear
rm -r ~/.kube/*
sudo iptables-save | grep -i cali | sudo iptables -F && sudo iptables-save | grep -i cali | sudo iptables -X
sudo iptables -n -L
