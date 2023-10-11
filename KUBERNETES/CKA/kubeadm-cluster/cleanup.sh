#!/bin/bash

# Define the number of nodes in the cluster
NUM_NODES=4

# Define the Docker image to use for the nodes
IMAGE=debian:bullseye-slim

# Define the network name for the cluster
NETWORK=kube-net

# Define the names for the nodes
NODE_NAMES=("node-1" "node-2")

# Define the IP addresses for the nodes
NODE_IPS=("192.168.1.1" "192.168.1.2")

# Define the Kubernetes version to use
K8S_VERSION=1.22.2-00

# Cleanup
for ((i=0;i<$NUM_NODES;i++)); do
  # Remove the Docker container
  docker rm -f ${NODE_NAMES[$i]}
done

# Remove the Docker network
docker network rm $NETWORK

# Reset Kubernetes on all nodes
for ((i=0;i<$NUM_NODES;i++)); do
  docker run --rm --name ${NODE_NAMES[$i]} --hostname ${NODE_NAMES[$i]} --net $NETWORK $IMAGE sh -c "kubeadm reset -f && iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X"
done