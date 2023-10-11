# Prerequisites
```sh
# Install the following
# Go, K8s cluster, kubernetes operator sdk
```

# 1. Generate Boilerplate code
```sh
operator-sdk init
```

# 2. Create APIs and CRD
```sh
# The following command creates an API and labels it Traveller through the --kind option
operator-sdk create api --version=v1alpha1 --kind=Traveller
Create Resource [y/n]
y
Create Controller [y/n]
y

# We have asked the command also to create a controller to handle all operations corresponding to our kind. The file defining the controller is named traveller_controller.go.

```

# 3. Download the Dependencies
```sh
```

# [Reference-Link](https://developers.redhat.com/articles/2021/09/07/build-kubernetes-operator-six-steps#build_the_kubernetes_operator)