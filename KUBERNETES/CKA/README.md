# Notes

## Introduction

- [freecodecamp-cka](https://www.freecodecamp.org/news/certified-kubernetes-administrator-study-guide-cka/)

### kubectl commands 

```sh
# create pods using public images
kubectl run redis --image redis

# edit the redis pod
kubectl edit pod redis 

# replace/update pod
kubectl replace -f filename.yml

# scale replicaset
kubectl scale --replicas=3 -f replicaset.yml

# preview a deployment/pod before sending to the cluster
# --dry-run=client flag to preview the object that would be sent to your cluster, without really submitting it.
kubectl run nginx --image=nginx --dry-run=client -o yaml

# output an image, edit and deploy. eg; nginx
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > sample-nginx.yml

# Service trying to reach another service in a different namespace: eg; blue-service --> red-service (namesapce=dev)
ping <service-name>.<namespace>.svc.cluster.local
ping red-service.dev.svc.cluster.local

```

## Example Assignment 

- Create a new Deployment with the below attributes 
using your own deployment definition file.

```yaml
Name: httpd-frontend;
Replicas: 3;
Image: httpd:2.4-alpine

# solution
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=3 
```

## Kubernetes Labels

```sh
# Add Labels to a Node
kubectl label node <node-name> key=value

## You can add Labels to Nodes. Then schedule Pods on the Labeled Nodes using nodeSelectors in the "spec.nodeSelectors" block of the Pod to match the Label in the Node

```

## Taints and Tolerations

- Nodes are `tainted` (kinda like paint/color/flagrance).

- Pods that are `tolerant` to the taints(color/scent) are scheduled on the Nodes, else if they can't, the taint-effect chosen will be applied to the unscheduled pods

- `Taints -- are done on Nodes.`

- `Tolerations -- are done on the Pods`

- `Note:` Taints and Tolerations does NOT tell a Pod to go to a particular Node, instead, it tells the Node to accept Pods with certain tolerations (meaning Pods with tolerations can still be scheduled to other Nodes). To specify a Node that a Pod should go to, use `NodeAffinity`

## Taint Example
```sh
kubectl taint node <node-name> key=value:taint-effect

# Example:
kubectl taint node <node-name> app=blue:NoSchedule
```

- `taint-effect` is what happens to Pods that are not tolerant to the taint. The options are

1. Noschedule  
2. PreferNoSchedule  
3. NoExecute

## Toleration Example.

- Copy the `key`, `value`, `equal sign`, and `taint-effect` in `kubectl taint node <node-name> app=blue:NoSchedule` to the Pod yaml `spec.tolerations` section

```yaml
# Example:
tolerations:
- key: "app"
  operator: "Equal"
  value: "blue"
  taint-effect: "NoSchedule"
```


## NodeAffinity and PodAffinity
- Node affinity attracts pods to nodes, and pod affinity attracts pods to pods.

- `Kubernetes nodeAffinity`: Kubernetes node affinity is a feature that enables administrators to match pods according to the labels on nodes.

- `Pod Affinity`: Pod affinity provides administrators with a way to configure the scheduling process using labels configured on the existing pods within a node.
- You basically schedule incoming pods onto a Node based on the existing labels on pods existing on those nodes


## Required Vs Preferred Rules
- Both node affinity and pod affinity can set required and preferred rules that act as hard and soft rules. You can configure these rules with the following fields in a pod manifest:


```sh
```

## Kubernetes Networking 101

- When you set up a `Single-Node` kubernetes cluster, a network of `10.244.0.0` is created. All pods within Node are going to be assigned IP Addresses within the network range. Eg: 10.244.0.1, 10.244.0.2 etc. Pods can communicate within the internal network with the IP Addresses

- However, in a `Multi-Node` cluster, a third party networking tool is used to manage and create the network IPs for the nodes. Each node is assigned a network say, Node-1 with address 10.244.0.1 , Node-2 with address of 10.244.0.2. All pods within their nodes can be assigned IPs from their Node's network can therefore communicate. 

- Example of networking tools are `CISCO`, `Flannel`, `VMWare`, `NSX`, `Celium` etc.


## Static Pods

- The kube `api-server` and `kube-scheduler` are responsible in helping the kubelet in each node not to load pods. If there is no api-server (meaning no master node, no scheduler), the kubelet has a second way of scheduling pods.

- The kubelet schedule pods from a configuration directory (nodes' manaifest folder) within each node. The node's manifest folder can be set to desired directory but usually preferrd to be `etc/kubernetes/manifests`

- These pods created are called `STATIC PODS`. They are not managed by tha api-server and kube-scheduler but as a read-only objects to them

- For the static pods, their names usually have the `node` post-fix to the pod name. Etc

```sh
kubectl get pods

# results
web-app-node01
```

## Use Case of Static Pods

- Since `static pods` are NOT dependent on the control plane, a good use of it is to use it to create/configure the control plane components themselves

- Start by installing `kubelet` in all `master nodes`. Then configure all the different controller plane components (api-server, scheduler, etcd, etc) in the nodes' manifests directories. The kubelet will spin up those pods and recreate them when they fail

## Finding the static pod path manifests

```sh
# Find the static name (usually with the node-name post-fix). Eg;
web-app-node01

# ssh into the node //or use its IP
ssh node01

# identify kubelet config file in the node
ps -aux | grep /usr/bin/kubelet

# From the output you can see the --config=/var/lib/kubelet/config.yaml. This can be different, but be in the look out for --config

# cat the --config directory and look for staticPodPath
cat /var/lib/kubelet/config.yaml | grep -i staticPodPath

# output
staticPodPath: /etc/kubernetes/manifests
```

## Multiple Schedulers

- Kubernetes provides a `kube-scheduler` that takes care of scheduling Pods on nodes out of the box. It is static Pod that runs in the Node's manifests directory, mostly in `/etc/kubernetes/manifests`, but not all the time

- A part of the file contents look like this

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    component: kube-scheduler
    tier: control-plane
  name: my-scheduler
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-scheduler
    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
    - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
    - --bind-address=127.0.0.1
    - --kubeconfig=/etc/kubernetes/scheduler.conf
    - --leader-elect=false
    - --port=0
    image: k8s.gcr.io/kube-scheduler:v1.20.0
    imagePullPolicy: IfNotPresent

...more

```

- To create your own custom scheduler, create your manifest in the Node's manifest directory and make a copy of the kube-scheduler configuration and edit it

- Edit Pod name to desired name, say `my-scheduler`

- Edit `--leader-elect` to `false` so that the `kube-scheduler` still remains the lead scheduler

- Add `--scheduler-name=my-scheduler`

- Disable HTTPS by adding `--secure-port=0`

- Edit `--port=0` to a custom port of say `--port=10260`

- Edit `spc.containers.livessProbe.httpGet.port` with the chosen port number `10260`

- Putting everything together:

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    component: my-scheduler
    tier: control-plane
  name: my-scheduler
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-scheduler
    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
    - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
    - --bind-address=127.0.0.1
    - --kubeconfig=/etc/kubernetes/scheduler.conf
    - --leader-elect=false
    - --port=10260
    - --scheduler-name=my-scheduler
    - --secure-port=0
    image: k8s.gcr.io/kube-scheduler:v1.19.0
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 10260
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: kube-scheduler
    resources:
      requests:
        cpu: 100m
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 127.0.0.1
        path: /healthz
        port: 10260
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /etc/kubernetes/scheduler.conf
      name: kubeconfig
      readOnly: true
  hostNetwork: true
  priorityClassName: system-node-critical
  volumes:
  - hostPath:
      path: /etc/kubernetes/scheduler.conf
      type: FileOrCreate
    name: kubeconfig
status: {}
```

## Use the custom scheduler to create a Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  schedulerName: my-scheduler
  containers:
  - image: nginx
    name: nginx
```

## Logginng and Monitoring

## Cluster components monitoring

- The `kubelete`, a component that manages each Node in a cluster also has another component called `cAdvisor`(container advisor) which exposes performance metrics of Pods to the `kube api-server`

- NB: `metrics-server` is a minimal monitoring component

- ``metrics-server`` server can be gotten on: 

```sh
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
kubectl apply -f kubernetes-metrics-server/

# sample metrics
kubectl top node

# node that cosumes high memory
kubectl top node --sort-by='memory'

# pod that consumes most memory
kubectl top pod --sort-by='memory'
```

## Managing Application Logs

- Native kubernetes logging is performed on a running `Pod`

- Let's take an example Pod. For a single container in a Pod as shown below, You can get logs with the command

```sh
kubectl logs -f event-simulator-pod
```

```yaml
# A Pod with 1 container
apiVersion: v1
kind: Pod
metadata:
name: event-simulator-pod
spec:
containers:
  - name: event-simulator
    image: kodekloud/event-simulator
```

- For multiple containers in a Pod, you must specify the container

```sh
# syntax
kubectl logs -f <pod-name> <container-name>

# example
kubectl logs -f event-simulator-pod image-processor
```

```yaml
apiVersion: v1
kind: Pod
metadata:
name: event-simulator-pod
spec:
containers:
  - name: event-simulator
    image: kodekloud/event-simulator

  - name: image-processor
    image: some-image-processor
```

## Application Lifecycle Management 

- kubernetes `rollout` command is used for managing application lifecycle.

- Its options incluse `status, history, undo`, etc. Use `kubectl rollout --help` to see more

- For rolling to a previous version (previous image:tag deployed), use `rollout undo`

```sh
kubectl rollout undo deployment/<deployment-name> 
```

- Running `rollout undo` multiple times will only switch between the `current` and `previous` deployments. 

- To allow rollout to a specific version use the `--to-revision=<number>` flag

- Rollout also applies to `daemonsets, `


## Commands and Arguments in Docker

### Quick Docker Notes -- Difference b/n CMD and ENTRYPOINT

**CMD**:

- `CMD` takes in arguments with the first being an executable followed by parameters. When the container starts, all the arguments run at once

```sh
# Dockerfile
FROM Ubuntu
CMD ["sleep", "5"]
```

- To update the `CMD` for the docker container during runtime, you must pass in the entire `CMD` arguments, thus:

```sh
docker run ubuntu-sleeper sleep 5
```

**ENTRYPOINT**

- The `ENTRYPOINT` can take the executable command only

```sh
FROM Ubuntu
ENTRYPOINT ["sleep"] 
```

- You can then update the `ENTRYPOINT` command by passing ONLY the argument to it which then gets append to form `sleep 5` in the container

```
docker run ubuntu-sleeper 5
```

- NB: To pass a default argument to `ENTRYPOINT` in the Dockerfile, use it together with `CMD`

```sh
FROM Ubuntu
ENTRYPOINT ["sleep"]
CMD ["5"]
```

## Commands and Arguments in Kubernetes Pod

- To understand this better, refer to `Commands and Arguments in Docker` above

- In Kubernetes Pods:

* `ENTRYPOINT` field in Docker corresponds to `command` field in kubernetes
* `CMD` field in Docker corresponds to `args` in kubernetes 

- Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubuntu-sleeper
      image: ubuntu-sleeper
      command: ["sleep"]
      args: ["5"]

```

- NB: You can run this syntax (commands and arguments as list)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubuntu-sleeper
      image: ubuntu-sleeper
      command:
      - "sleep"
      - "5"

```

## Configure Environment Variables in Applications

- Environment variables are `key:value` pairs inputed to a yaml manifests. There are different ways of fetching the `values` for the `keys`

1. `Plain Key Value`

```yaml
env:
  name: color
  value: blue
```

2. `ConfigMap`

```yaml
env:
  name: color
  valueFrom:
    configMapKeyRef:
      name: app-config  # configmap name
      key: color        # provide only the key

```

3. `Secrets`

```yaml
env:
  name: color
  valueFrom:
    secretKeyRef:

```

## ConfigMaps

- These are yaml manifests that store configuration data of Pods as key/value pairs

- You can create ConfigMaps and inject them into the Pods

- You can create ConfigMaps `Imperatively` from the CLI and `Declaratively` via manifests

1. `Imperative Approach:`

```sh
# syntax
kubectl create configmap <chosen-name> \
 --from-literal=APP_COLOR=blue

# example using key/value --> use --from-literal
kubectl create configmap app-config \
 --from-literal=APP_COLOR=blue

# example fetching key/value from file --> use --from-file
kubectl create configmap app-config \
 --from-file=env-file
```

2. `Declarative Approach:` 

- Note: This injects single env variables

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: development

```

- Inject values from and an `ENTIRE` ConfigMap to a Pod manifest. 

- Note difference b/n `configMapKeyRef` for single env variables and `configMapRef` for an entire configmap yaml file

```yaml
...
- containers:
  - name: simple-app
    envFrom:
      - configMapRef:
          name: app-config
```
        

## Secrets

## Create A Secret

- `Secrets` are pretty much like `configMaps` but the major difference is that, while configMaps values are stored as plain texts, secrets are hashed and stored 

- Ways of creating secrets 

1. `Imperative Approach`:

```sh
# syntax
kubectl create secret generic <secret-name> \
--from-literal=<key>=<value>

# example secret from key/values
kubectl create secret generic app-secret \
--from-literal=DB_HOST=mysql

# example secret from --> a file
kubectl create secret generic app-secret \
--from-file=env.secrets
```

2. `Declarative Approah`:

- First encode the secret on your Terminal using `base64` and use the encoded value for your secret

- Values to convert are:

```yaml
DB_Host: mysql
DB_User: root
DB_password: passwrd
```

- Conversion process:

```sh
# encode DB_Host
echo -n "myql" | base64
kUYsdH7we=

# encode DB_User
echo -n "root" | base64
osiu4Fw2=

# encode DB_password
echo -n "passwrd" | base64
b4Xdojis=
```

- Inject the `base64` encoded values into the secret yaml manifest

```yaml
apiVersion: v1
kind: Secret 
metadata:
  name: app-secret
data:
  DB_Host: kUYsdH7we=
  DB_User: osiu4Fw2=
  DB_password: b4Xdojis=

```

- To Decond a Secret use same procedure above will a little tweak (pass --decode to base64)

```sh
# Decond DB_Host kUYsdH7we=
echo -n "kUYsdH7we=" | base64 --decode
```

## Inject Secret To A Pod

1. `Inject whole secret file`

```yaml
envFrom:
  - secretRef:
      name: app-secret
```

2. `Inject single secret as ENV`

```yaml
env:
  - name: DB_Password
    valueFrom:
      secretKeyRef:
        name: app-secret
        key: DB_Password
```


# Cluster Maintenance

- `pod eviction timeout`: This is the time it takes for the controller to wait for a Node to online before it evicts all pods from the worker Node after it's down. The default is 5minutes. If a Node is down for more than 5minutes, then all pods are evicted from the Node

- If the Node was down for less than the `pod-eviction-time`, the pods will be rescheduled on it

- The `pod-eviction-timeout` is passed to the controller during cluster set up perid

```sh
kube-controller-manager --pod-eviction-timeout=5m0s
```

## Kubernetes "drain", "uncordon", and "cordon"

- `drain`: Evicts all pods and make node unschedulable

- `cordon`: Only makes a Node unschedulable without evicting pods

- `uncordon`: Makes a Node schedulable again


## etcd Backup

- To see all the options for a specific sub-command, make use of the -h or –help flag.

- For example, if you want to take a snapshot of etcd, use:

```sh
etcdctl snapshot save -h  # keep a note of the mandatory global options.
```

Since our ETCD database is TLS-Enabled, the following options are mandatory:

```yaml
–cacert                         # verify certificates of TLS-enabled secure servers using this CA bundle

–cert                           # identify secure client using this TLS certificate file

–endpoints=[127.0.0.1:2379]     # This is the default as ETCD is running on master node and exposed on localhost 2379.

–key                            # identify secure client using this TLS key file
```

# TLS Certificates

1. Server Certificates: are generated for servers

2. Certificate Authorities (CA) are third-party vendors that issue certificates eg; Symantec, Digicert, etc

3. Client certificates are generated in the client side

## How to Spot Private and Public keys

```sh
# Public key
# extensions: *.crt and *.pem
server.crt
server.pem
client.crt
client.pem

# Private key
# extension *.key, *-key.pem
server.key
server-key.pem
client.key
client-key.pem

```

## Server Components of Kubernetes

- These server components use TLS certificates to authenticate with their clients. Below are the server componets of a kubernetes environment

```yaml
1. kube-apiserver:
public certificate -- apiserver.crt
private key -- apiserver.key

2. etcd server:
public certificate -- etcdserver.crt
private key -- etcdserver.key

3. kubelet server:
public certificate -- kubelet.crt
private key -- kubelet.key

```

## Client Components of Kubernetes

- Clients are those that make request to the server components of k8s mentioned above

- These clients need to also have privated keys (`.key`) and public keys/locks (`.crt or .pem`) 


## Clients to Kube-apiserver

- Some clients that make requests to the `kube-apiserver` are:

```yaml
1. admins: 
admin.crt -- public certificate
admin.key -- private key

2. kube-scheduler:
scheduler.crt -- public
scheduler.key -- private

3. kube-controller-manager:
kube-controller.crt
kube-controller.key

4. kube-proxy:
kube-proxy.crt
kube-proxy.key
```

## Clients to etcd server

1. `kube-apiserver`: The only service that talks to the etcd server


## Clients to kubelet server
1. `kube-apiserver`


## Tools for generating Certificates

1. OPENSSL
2. CFSSL 
3. EASYRSA
