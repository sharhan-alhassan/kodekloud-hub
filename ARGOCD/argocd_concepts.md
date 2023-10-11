# Concepts

```sh
# 1. Application: A group of Kubernetes resources as defined by a manifest. This is a Custom Resource Definition (CRD).

# 2. Application source type: Which Tool is used to build the application.

# 3. Target state: The desired state of an application, as represented by files in a Git repository.

# 4. Live state: The live state of that application. What pods etc are deployed.

# 5. Sync status: Whether or not the live state matches the target state. Is the deployed application the same as Git says it should be?

# 6. Sync: The process of making an application move to its target state. E.g. by applying changes to a Kubernetes cluster.

# 7. Sync operation status: Whether or not a sync succeeded.

# 8. Refresh: Compare the latest code in Git with the live state. Figure out what is different.

# 9. Health: The health of the application, is it running correctly? Can it serve requests?

# 10. Tool: A tool to create manifests from a directory of files. E.g. Kustomize. See Application Source Type.

# Configuration management tool See Tool.

# Configuration management plugin A custom tool.
```