# API Versioning

## Alpha:
- The version names contain alpha (for example, v1alpha1).

- The software is recommended for use only in short-lived testing clusters, due to increased risk of bugs and lack of long-term support.


## Beta:

- The version names contain beta (for example, v2beta3).

- The software is not recommended for production uses. Subsequent releases may introduce incompatible changes. If you have multiple clusters which can be upgraded independently, you may be able to relax this restriction.


## Stable:
- The version name is vX where X is an integer.

- The stable versions of features appear in released software for many subsequent versions.


# Kubernetes API Structure

## Resources and Verbs

-  It's important to differentiate a `resource` as a certain `kind of objects` from a `resource` as a `particular instance of some kind.`

-  Thus, Kubernetes `API endpoints` are officially named `resource types`  to avoid ambiguity with the resource instances. 

- However, in the wild, `endpoints` are often called just `resources`, and the actual meaning of the word is derived from the context.

- For extensibility reasons, `resource types `are organized into `API groups`, and the groups are `versioned` independently from each other:

```sh
# Get all the api resources/resource types/endpoints -- with verbose
kubectl get api-resources -o wide

# 
kubectle api-       # tab
api-resources  -- Print the supported API resources on the server
api-versions   -- Print the supported API versions on the server, in the form of "group/version"
```

- The call is made to the special `/api` and `/apis/<group-name` resources

- The `/api` endpoint is already legacy and termed as the `core` group. A modern endpoint is the `/apis/<group-name`

## Call the API resources (endpoints)

```sh
# make the api available on localhost
kubectl proxy
Starting to serve on 127.0.0.1:8001

# list all known API paths
curl localhost:8001

# list all known versions of the 'core' group
curl localhost:8001/api

# list all known versions of the 'core/v1' group
curl localhost:8001/api/v1

# Get a particular pod resource
curl localhost:8001/api/v1/namespaces/default/pods/nginx-6799fc88d8-glmnn

# List known groups (all but `core`)
curl localhost:8001/apis

# List known versions of the `apps` group 
$ curl http://localhost:8001/apis/apps

```

- There is a simpler way to examine the Kubernetes API: `kubectl get --raw /SOME/API/PATH`. 

- You can format the output with `| python -m json.tool` thereby becoming `kubectl get --raw /SOME/API/PATH | `

```sh
kubectl get --raw /api
```


# Kubernetes "Kind"

-  `Kind` is the name of an `object schema`

- In other words, a `kind` refers to a particular `data structure`, i.e. a certain composition of `attributes` and `properties`.

- `kinds` are grouped into three categories:

```yaml
1. Objects (Pod, Service, etc) - persistent entities in the system.

2. Lists - (PodList, APIResourceList, etc) - collections of resources of one or more kinds.

3. Simple - specific actions on objects (status, scale, etc.) or non-persistent auxiliary entities (ListOptions, Policy, etc).
```

- Object's `spec` -- is the `desired state`
- Object's `status` -- is the `actual state`


# Kubernetes Authentication

- Curl the kubernetes API server

```sh
# get the cluster server
KUBE_API=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')

# Perform curl 
curl $KUBE_API/version              # This will throw an error due to unverified certificate

# supress the certificate validation process with --insecure flag
curl --insecure $KUBE_API/version

```

