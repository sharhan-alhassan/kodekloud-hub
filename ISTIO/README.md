# Introduction

# Service Mesh
```yaml
- A dedicated and configurable infrastructure layer that handles the communication b/n services without having to change the code in a microservice architecture

- A `proxy` (side car container) is embededed into each microservice that takes care of `authentication, authorization, networking, logging, monitoring, tracing, etc`

- The side cars communicate to each other via the `data plane` and communicate to a service-side plane called `control plane` which manages all traffice going into all services

```

# Service Mesh provdes Service Discovery
```sh
- Service Discovery are:
1. Discovery
2. Health checks
3. Load balancing
```

# Istio
```sh
- Istion uses the open-source proxy tool `envoy` for its implementation
```

# Istio Control Plane Components
```yaml
1. `citadel`: Citadel manages certificates generation
2. `pilot`: For service discovery
3. `gallery`: Helps in validating configuration files

These 3 components are later combined to form a daemon called `istiod`

- Each pod has an `istio agent` alongside with the proxy(envoy)

- The `istio agent` passes configuration scripts to the proxy side cars
```

# Istio Installaton
- Methods of installation
```yaml
1. install with istioctl utility
2. istion operator install
3. install with Helm

1. using istioctl
istioctl install --set profile=demo -y
istioctl verify-install
# It installs 
a. istiod daemon -- the daemon itself
b. istio-ingressgateway
c. istio-egressgateway
```

# Install Istion
```sh
# download
curl -L https://istio.io/downloadIstio | sh -

# cd 
cd istio-1.14.0

# add istioctl client to path
export PATH=$PWD/bin:$PATH

# Install with a profile
# For this installation, we use the demo configuration profile. It’s selected to have a good set of defaults for testing, but there are other profiles for production or performance testing.
istioctl install --set profile=demo -y

# Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies when you deploy your application later:
kubectl label namespace daba istio-injection=enabled

# To disable the istion injection
kubectl label namespace daba istio-injection=disabled

# Use this command to see if istio is injected into pods
istioctl analyze

# NB: Istio is usually installed in `istio-system` namespace
```

# Installing Kiali Add-on
```sh
- A visualization tool for define, validate and observe microservices

- Analyze patterns

# start dashboard
istioctl dashboard kiali
```