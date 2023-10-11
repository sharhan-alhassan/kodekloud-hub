# commonLabels

```yml
- These are the labels that have same key/value names and appear in a group of files

- Eg://
# deployment.yml
labels:
  app: wordpress

# service.yml
labels:
  app: wordpress

# - In kustomization.yml -- use commonLables to inject app:wordpress into both deployment.yml and service.yml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: myapp
commonLabels:
  app: wordpress
resources:
- deployment.yml
- service.yml
```

# Build the file
```yml
- If you're using standalone kustomize

kustomize build ./path-to-kustomization-file

- if you're kubectl 
kubectl kustomize ./path
```

# Overlays
```yml
- Overlays have environment-specific files (Dev, QA, Staging or Production) that you want to apply to the base files

- You use patchesStrategicMerge to apply the files in overlays subdirectories
```