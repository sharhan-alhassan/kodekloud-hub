# Argocd Tutorial

# Prerequisite

```yaml
1. k8s cluster (king, minikube, etc)    # I'm using kind
2. kubectl 
3. git
4. argocd
```

# Installation

```sh
# create cluster
kind create cluster --name argocd

# Download argocd cli -- For local machine
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# Argo CLI Installation -- for Workflows (different from argo CLI) argocd controls a Argo CD server
curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.1.3/argo-linux-amd64.gz
gunzip argo-linux-amd64.gz
chmod +x argo-linux-amd64
sudo mv ./argo-linux-amd64 /usr/local/bin/argo
argo version --short 

# Prep alpine jump box
apk add curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# create container to access cluster -- alpine jump box
docker run --rm -it -v ${HOME}/.kube:/root/ -v ${PWD}:/work -w /work --net host alpine sh

docker run --rm -it -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host alpine sh

# kubernetes sample alpine jump box
kubectl run alpine -i --tty --image=alpine --rm=True --port=5000 --restart=Never -- sh

# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Patch the ArgoCD service from ClusterIP to a LoadBalancer: -- VERY IMPORTANT
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Install ingress-nginx-controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/cloud/deploy.yaml

# Patch ingress-nginx-controller deployment to disable ssl
kubectl edit deployment ingress-nginx-controller -n ingress-nginx 

# Add the below to .spec.containers.args
- args:
  - --enable-ssl-passthrough


# Patch the argocd-server deployment to add the insecure flag to enable http connections
kubectl edit deployment argocd-server -n argocd

# Add the below to the .spec.containers.command
- command:
  - argocd-server
  - --insecure
```

# Create an Ingress resource for argocd-server

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ingress
  namespace: argocd
  annotations:
    kubernetes.io/ingress.class: "nginx"
    alb.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: argocd-server
            port:
              name: http
    host: example.link.com
```

# Open on browser

```sh
# port-forward argocd-server service
kubectl port-forward svc/argocd-server -n argocd 8080:443

# The initial password for the admin account is auto-generated and stored as clear text in the field password in a secret named argocd-initial-admin-secret in your Argo CD installation namespace. You can simply retrieve this password using kubectl:

# Get argocd-server password
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo $argoPass
2tEZwKYJfPUAyCzJ

# Get argocd-server name
```

# Core Concepts

# 1. API Server
```sh
# The API server is a gRPC/REST server which exposes the API consumed by the Web UI, CLI, and CI/CD systems. 
```

# 2. Repository Server
```sh
# The repository server is an internal service which maintains a local cache of the Git repository holding the application manifests. It is responsible for generating and returning the Kubernetes manifests when provided the following inputs:

1. repository URL
2. revision (commit, tag, branch)
3. application path
4. template specific settings: parameters, helm values.yaml
```

# 3. Application Controller
```sh
# The application controller is a Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the repo). It detects OutOfSync application state and optionally takes corrective action. It is responsible for invoking any user-defined hooks for lifecycle events (PreSync, Sync, PostSync)
```

# Connection to ArgoCD CLI
## Prerequisite -- Deploy metallb controller in order to access LoadBalancer

# 4. Metallb Setup
- To use a LoadBalancer you will have to use Metallb controller. You can extend this with a domain name as we will demostrate

```sh
# create metallb namespace
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml

# Apply metallb manifest
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml


# Setup address pool used by loadbalancers
# To complete layer2 configuration, we need to provide metallb a range of IP addresses it controls. We want this range to be on the docker kind network.

docker network inspect -f '{{.IPAM.Config}}' kind

# The output will contain a cidr such as 172.19.0.0/16. We want our loadbalancer IP range to come from this subclass. We can configure metallb, for instance, to use 172.19.255.200 to 172.19.255.250 by creating the configmap.

```
*************************************

# 5. Fetch ArgoCD LoadBalancer, IP and Password
```sh
# Get LoadBalancer IP
LB_IP=$(kubectl get svc/argocd-server -n argocd -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Get password
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Login to ArgoCD server
argocd login --insecure --grpc-web $LB_IP --username admin --password $argoPass

admin:login' logged in successfully
Context '192.168.64.200' updated
```
```sh
# Check server context
argocd context
* 192.168.64.200  192.168.64.200
```

# Register a Deployment as an Application in ArgoCD
```yaml
# After deploying the app1, you need to register it as an applicaiton in ArgoCD server to monitor it

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bgd-app
  namespace: argocd
spec:
  destination:
    namespace: bgd
    server: https://kubernetes.default.svc 
  project: default 
  source: 
    path: apps/bgd/overlays/bgd
    repoURL: https://github.com/redhat-developer-demos/openshift-gitops-examples
    targetRevision: minikube
  syncPolicy: 
    automated:
      prune: true
      selfHeal: false
    syncOptions:
    - CreateNamespace=true
```

# Create ArgoCD Project
```sh
argocd proj create mm3-project --description "project for mm3-cluster apps"

➜  metallb-address-pools argocd proj list                                                           
NAME         DESCRIPTION                   DESTINATIONS  SOURCES  CLUSTER-RESOURCE-WHITELIST  NAMESPACE-RESOURCE-BLACKLIST  SIGNATURE-KEYS  ORPHANED-RESOURCES
default                                    *,*           *        */*                         <none>                        <none>          disabled
mm-project   project for mm-cluster apps   <none>        <none>   <none>                      <none>                        <none>          disabled
mm1-project  project for mm1-cluster apps  <none>        <none>   <none>                      <none>                        <none>          disabled
mm2-project  project for mm2-cluster apps  <none>        <none>   <none>                      <none>                        <none>          disabled
mm3-project  project for mm3-cluster apps  <none>        <none>   <none>                      <none>                        <none>          disabled

```

# Add Repository to ArgoCD
```sh
# Add Git repository
argocd repo add git@github.com:sharhan-alhassan/azure-aks.git --ssh-private-key-path ~/.ssh/id_rsa

Repository 'git@github.com:sharhan-alhassan/azure-aks.git' added

# Deploy the ArgoCD application for the manifest files
kubectl apply -f argocd-apps/bgd-app.yml

# Let’s introduce a change! Patch the live manifest to change the color of the box from blue to green:
kubectl -n bgd patch deploy/bgd --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/env/0/value", "value":"green"}]'
```

# Add another Cluster to ArgoCD
```sh
# Works for Kind
# 1. First make sure to have all "contexts" and "cluster-names" in one kubeconfig file
~/.kube/config      # by default

# 2. Fetch the endpoint (IP) of the cluster -- For kind, the endpoint in the kubeconfig file will be the localhost, so fetch node/container IP rather else you'll the following error
FATA[0001] rpc error: code = Unknown desc = Get "https://127.0.0.1:32768/version?timeout=32s": dial tcp 127.0.0.1:32768 connect: connection refused 

# 3. Make sure to be in the context of hte cluster you want to register in the ArgoCD server
kubectl get endpoints                        
NAME         ENDPOINTS           AGE
kubernetes   192.168.64.2:6443   37h

# 4. Find the entry belonging to the cluster in your .kube/config, and change the server entry:
- cluster:
    certificate-authority-data: ...
    server: https://192.168.64.6:6443
  name: yourcontext

kubectl config set-cluster kind-mm1 --server=https://192.168.64.6:6443

# 4. 
Verify that kubectl get pods is still working, then try argocd cluster add
```
```sh
# Add the cluster IP to the ArgoCD server
argocd cluster add kind-mm1     

WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `kind-mm1` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0001] ServiceAccount "argocd-manager" already exists in namespace "kube-system" 
INFO[0001] ClusterRole "argocd-manager-role" updated    
INFO[0001] ClusterRoleBinding "argocd-manager-role-binding" updated 
Cluster 'https://192.168.64.3:6443' added
➜  ARGOCD 
```

# Add Metrics Server to Kind cluster
```yml
# Add the below the metrics-server deployment object
args:
    - --kubelet-insecure-tls
    - --kubelet-preferred-address-types=InternalIP

# Then Deploy
kubectl apply -f metrics-server/metrics-server.yml
```

# Build with Kustomization YAML
```yaml
# For full file details refer to ./kustomization directory

# 1. Operation In kustomization.yaml
- patch: |-
    - op: add                                 # operatin is to add an item
      path: /metadata/labels/testkey          # The path to add a new label called "testkey"
      value: testvalue                        # The value of testkey is testvalue

# output of "kustomize build .
...
metadata:
  labels:
    app: welcome-php
    testkey: testvalue

# 2. Operation In kustomization.yaml
images:
- name: quay.io/redhatworkshops/welcome-php   
  newTag: ffcd15                              # Add newtag value to the image

# output of "kustomize build .
spec:
  containers:
  - image: quay.io/redhatworkshops/welcome-php:ffcd15
    name: welcome-php

```

# Edit with Kustomize CLI
```sh
# Change Deployment image tag from "latest" to ffcd15
kustomize edit set image quay.io/redhatworkshops/welcome-php:ffcd15

# Pipe output to kubectl
kustomize build . | kubectl apply -f -
```

# Sync Waves and Hooks
```yaml
# Sync Waves arranges the order in which your deployments are done

# It's done by adding adding an annotation value so that deployment precedence starts with lower values first before large values

# Namesapce sync-wave
kind: Namespace
...
annoatations:
  argocd.argoproj.io/sync-wave: "-1"    # Namespace Will deploy first

---
# Deployment sync-wave
kind: Deployment
...
annoatations:
  argocd.argoproj.io/sync-wave: "0"     # Deployment Will deploy first
```
## When Argo CD starts a sync action, the manifest get placed in the following order:
```sh
# 1. The wave the resource is annotated in (starting from the lowest value to the highest)
# 2. By kind (Namespaces first, then services, then deployments, etc …​)
# 3. By name (ascending order)
```

### NOTE: Argo CD won’t apply the next manifest until the previous reports "healthy".
****
# Resource Hooks
- Controlling your sync operation can be further redefined by using hooks. These hooks can run before, during, and after a sync operation. These hooks are:

```sh
# 1. PreSync - Runs before the sync operation. This can be something like a database backup before a schema change

# 2. Sync - Runs after PreSync has successfully ran. This will run alongside your normal manifests.

# 3. PostSync - Runs after Sync has ran successfully. This can be something like a Slack message or an email notification.

# 4. SyncFail - Runs if the Sync operation as failed. This is also used to send notifications or do other evasive actions.
```

```
# AiFi Login
```sh
argocd login --grpc-web argocd.operations.us.aifi.io:443 --username admin --password pentagram-hunter-rectified3
```


# ArgoCD Notifications
## Using Email Service
```yaml
# Install Argo CD Notifications
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/release-1.0/manifests/install.yaml

# Install Triggers and Templates from the catalog
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/release-1.0/catalog/install.yaml

# Add Email username and password token to argocd-notifications-secret secret
export EMAIL_USER=samhas@gmail.com
export PASSWORD=****
kubectl apply -n argocd -f - << EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-notifications-secret
stringData:
  email-username: $EMAIL_USER
  email-password: $PASSWORD
type: Opaque
EOF

# Register Email notification service
kubectl patch cm argocd-notifications-cm -n argocd --type merge -p '{"data": {"service.email.gmail": "{ username: $email-username, password: $email-password, host: smtp.gmail.com, port: 465, from: $email-username }" }}'
```

```yaml
#
kubectl patch app mm-app-01 -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-sync-succeeded.gmail":"samhassan1010@gmail.com"}}}' --type merge
```

# 3. Several pods do not start, encounter "too many open files" error #2087
```sh
# (10x previous values) solved this problem on k0s instance
sudo sysctl fs.inotify.max_user_instances=1280
sudo sysctl fs.inotify.max_user_watches=655360
```sh

```
# AiFi Solution

1. Use unzip during installations
- argocd-server It's a gRPC/REST The server , It's public Web UI The use of API. You can do this by enabling GZIP Compress --enable-gzip Option to configure

https://chowdera.com/2022/195/202207140857551116.html


- Augment with notificatios

2. Seperate argocd server from other workloads

3. Taints and tolerations for argocd nodes in the cluster

4. What is the sync policy for each application


Unveil the Secret Ingredients of Continuous Delivery at Enterprise Scale with Argo CD:

https://blog.akuity.io/unveil-the-secret-ingredients-of-continuous-delivery-at-enterprise-scale-with-argo-cd-7c5b4057ee49

