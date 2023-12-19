#!/bin/sh

export $(cat .env.local | xargs)

sudo kubeadm init --pod-network-cidr=$K8S_NETWORK_CIDR --apiserver-advertise-address=$K8S_IP_MASTER_NODE
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

cilium install
cilium hubble enable

sudo kubeadm token create --print-join-command
