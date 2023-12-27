# K8s-init

### All nodes
```bash
curl https://raw.githubusercontent.com/unixoff/k8s-init/master/ubuntu.22.04.sh | bash
```

### Master node
```bash
curl https://raw.githubusercontent.com/unixoff/k8s-init/master/master.sh | bash
```

### Worker node
Join worker nodes. 
If you forget join token run the command on master node:
```bash
sudo kubeadm token create --print-join-command
```

### Init stage env
Create .env.local like .env and run the command on master node:
```
curl https://raw.githubusercontent.com/unixoff/k8s-init/master/init.sh | bash
```
