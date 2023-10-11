
# Here are the steps to create a four-node Kubernetes cluster using kubeadm on Docker containers with the Debian image:

```sh
# 1. Install Docker on each node:
sudo apt-get update
sudo apt-get install -y docker.io

# 2. Install kubeadm, kubelet, and kubectl on each node:
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 3. Disable swap on each node:
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


# 4. Initialize the Kubernetes cluster on the first node:
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# -- This will output a kubeadm join command that you'll need to run on the other nodes to join them to the cluster.

# 5. Set up the kubectl configuration on the current user:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 6. Install the Flannel network plugin to enable pod networking:
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# 7. Run the kubeadm join command on the other nodes:
sudo kubeadm join <MASTER_NODE_IP>:<MASTER_NODE_PORT> --token <TOKEN> --discovery-token-ca-cert-hash <DISCOVERY_TOKEN_CA_CERT_HASH>

# 8. Verify that all nodes have joined the cluster by running the following command on the master node:
kubectl get nodes

```