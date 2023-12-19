#!/bin/sh

export $(cat .env.local | xargs)

# sudo sysctl --system
#
# systemctl enable containerd
# systemctl restart containerd

sudo rm -r /home/$K8S_USER_CI_CD/.kube/*
sudo cp -i /etc/kubernetes/admin.conf /home/$K8S_USER_CI_CD/.kube/config
sudo chown $K8S_USER_CI_CD:$K8S_USER_CI_CD /home/$K8S_USER_CI_CD/.kube/config

kubectl create ns stage
kubectl -n stage create secret docker-registry docker-hub --docker-server=$K8S_DOCKER_SERVER --docker-username=$K8S_DOCKER_USERNAME --docker-password=$K8S_DOCKER_PASSWORD --docker-email=$K8S_DOCKER_EMAIL
kubectl -n stage create configmap kubectl-config --from-file=$HOME/.kube
kubectl -n stage create configmap helm-config --from-file=$HOME/.helm

kubectl apply -f ./ingress/deploy.yaml
kubectl apply -f ./dashboard/recommended.yaml
