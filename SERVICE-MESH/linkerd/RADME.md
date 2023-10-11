# Introduction 

## Set up kind cluster

```sh
kind create cluster --name linkerd

```

## Set up an alpine container to access the cluster

- We want to use a small alpine container to install our needed tools such as `kubectl, vim, linkerd` and use it to access our kind k8s cluster

```sh
# for docker: run and delete after exiting
docker run -it --rm -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host alpine sh

# for kubernetes: run a pod
kubectl run alpine -it --rm --image=alpine --restart=Never -n daba -- sh

# Run the pod as a function named, kcdebug
kcdebug() { kubectl run alpine -it --rm --image=alpine --restart=Never -n daba -- sh }

# Run the function
kcdebug
```

## Install curl & kubectl in alpine container

```sh
apk add --no-cache curl vim
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
export KUBE_EDITOR="nano"

#test cluster access:
/work # kubectl get nodes
NAME                    STATUS   ROLES    AGE   VERSION
linkerd-control-plane   Ready    master   26m   v1.19.1
```


# Linkerd CLI Installation
```sh
# instal linkerd cli
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh

# add to path
sudo mv ~/.linkerd2/bin/linkerd /usr/local/bin 

# check version
linkerd version
```
# Linkerd Installation to Kubernetes
```sh
# check all the manifests to be installed in your k8s cluster
linkerd install         # if error add: --set proxyInit.runAsRoot=true

# now apply those manifests
linkerd install | kubectl apply -f -

# confirm installation is complete
linkerd check

# Install linkerd dashboard & on-cluster metrics
linkerd viz install | kubectl apply -f -

# Open dashboard
linkerd viz dashboard          

# NB: To create a standonline UI for viz dashboard, note the svc named "web" in linkerd-viz namespace and create an ingress for it
```
# Linkerd Sample App
```sh

```


```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://7389B3C6AE4BB3980CEAC2C3BAAC74D8.gr7.us-east-1.eks.amazonaws.com
  name: eks_daba-prod
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://127.0.0.1:37825
  name: kind-busybox
contexts:
- context:
    cluster: eks_daba-prod
    user: eks_daba-prod
  name: eks_daba-prod
- context:
    cluster: kind-busybox
    user: kind-busybox
  name: kind-busybox
current-context: kind-busybox
kind: Config
preferences: {}
users:
- name: eks_daba-prod
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - token
      - -i
      - daba-prod
      command: aws-iam-authenticator
      env: null
      interactiveMode: IfAvailable
      provideClusterInfo: false
- name: kind-busybox
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
```