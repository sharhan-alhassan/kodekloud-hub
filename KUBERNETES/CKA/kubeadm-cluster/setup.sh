#!/bin/bash

# Define the number of nodes in the cluster
NUM_NODES=2

# Define the Docker image to use for the nodes
IMAGE=debian

# Define the network name for the cluster
NETWORK=kube-net

# Define the names for the nodes
NODE_NAMES=("node-1" "node-2")

# Define the IP addresses for the nodes
NODE_IPS=("192.168.1.1" "192.168.1.2")

# Define the Kubernetes version to use
K8S_VERSION=1.22.2-00

# Create the Docker network for the cluster
docker network create $NETWORK

# Create the Docker containers for each node
for ((i=0;i<$NUM_NODES;i++)); do
  docker run -d --name ${NODE_NAMES[$i]} --hostname ${NODE_NAMES[$i]} --net $NETWORK $IMAGE sleep infinity
done

# Install Kubernetes and set up the cluster
for ((i=0;i<$NUM_NODES;i++)); do
  # Install Kubernetes dependencies
  docker exec ${NODE_NAMES[$i]} bash -c "sudo apt-get update"
  docker exec ${NODE_NAMES[$i]} bash -c "apt-get install -y systemd"
  docker exec ${NODE_NAMES[$i]} bash -c "apt-get install gnupg -y"
  docker exec ${NODE_NAMES[$i]} bash -c "apt-get install -y docker.io"
  
  # Install Kubernetes components
  docker exec ${NODE_NAMES[$i]} bash -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
  docker exec ${NODE_NAMES[$i]} bash -c "apt-get update && apt-get install -y apt-transport-https curl"
  docker exec ${NODE_NAMES[$i]} bash -c "echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
  docker exec ${NODE_NAMES[$i]} bash -c "apt-get update && apt-get install -y kubelet=$K8S_VERSION kubeadm=$K8S_VERSION kubectl=$K8S_VERSION"
  docker exec ${NODE_NAMES[$i]} bash -c "apt-mark hold kubelet kubeadm kubectl"
  docker exec ${NODE_NAMES[$i]} bash -c "sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab"
  
  # Set up the cluster on the first node
  if [ $i -eq 0 ]; then
    # Initialize the cluster
    docker exec ${NODE_NAMES[$i]} bash -c "kubeadm init --pod-network-cidr=10.244.0.0/16"
    
    # Set up kubectl configuration
    mkdir -p $HOME/.kube
    docker cp ${NODE_NAMES[$i]}:/etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
    
    # Set up networking
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  else
    # Join the other nodes to the cluster
    JOIN_COMMAND=$(docker exec ${NODE_NAMES[0]} bash -c "kubeadm token create --print-join-command")
    docker exec ${NODE_NAMES[$i]} bash -c "$JOIN_COMMAND"
  fi
done

