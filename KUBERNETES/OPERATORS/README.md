# 1. Control Loop in Kubernetes
```sh
# This is the core operational logic of kubernetes

# It compares the deired state (your yaml manifests) and the live/actual state in the cluster and sync them up

# Control loop cycle
# 1. Observer
# 2. Diff
# 3. Act
```

# 2. Operators
```sh
# In Deploying an Operator you also deploy the "OLM" (Operator Lifecycle Manager)

# An Operator consists of two things:
# 1. CRD -- Custom Resource Definitions (eg; deployment, pod, svc, etc): 
# 2. Controller -- Syncs Live state with Desired state
```

# What is Custom Resource Definitions (CRDs)
```sh
# 1. A custom resource is an object that adds to the existing Kubernetes API or allows you to introduce your own API into a project or a cluster.

# 2. A custom resource definition (CRD) is a file that defines its own object kinds and lets the API Server handle the entire lifecycle. Deploying a CRD into the cluster causes the Kubernetes API server to begin serving the specified custom resource.

# 3. When you create a new custom resource definition (CRD), the Kubernetes API Server reacts by creating a new REST API resource path, that can be used by the entire cluster or a single namespace. As with existing built-in objects, deleting a project deletes all custom objects in that project.



```

# 3. Levels of Maturity of Operator
```sh
# 1. Basic Install
# 2. Upgrades
# 3. Lifecycle
# 4. Insights
# 5. Autopilot
```
**********************************************
