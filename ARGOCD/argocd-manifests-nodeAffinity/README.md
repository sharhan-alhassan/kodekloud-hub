


# Deployments and StatefulSet
```yaml
deployment.apps/argocd-applicationset-controller created
deployment.apps/argocd-dex-server created
deployment.apps/argocd-notifications-controller created
deployment.apps/argocd-redis created
deployment.apps/argocd-repo-server created
deployment.apps/argocd-server created
statefulset.apps/argocd-application-controller created
```

# Label Node
```sh
# Dry run lable
kubectl label nodes mm-worker3 test-node-affinity=test -o yaml --dry-run=client

# Add Label
kubectl label nodes mm-worker3 test-node-affinity=test

# Remove Label -- Add a "-" at the end of the label
kubectl label nodes mm-worker3 test-node-affinity=test-
```

# Tolerations
```sh
# Taint a Node
kubectl taint nodes mm-worker3 argocd=false:PreferNoSchedule

# That toleration is basically a pass that will allow the pod onto any node with any taint.
tolerations:
- operator: Exists
```

# Commands
```sh
# Get all pods on a specific node
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=mm-worker3
```