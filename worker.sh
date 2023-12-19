#!/bin/sh

export $(cat .env.local | xargs)

sudo kubeadm join $K8S_IP_MASTER_NODE:$K8S_UFW_PORT --token $K8S_JOIN_TOCKEN --discovery-token-ca-cert-hash $K8S_JOIN_HASH
